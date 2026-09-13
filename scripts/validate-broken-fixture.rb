#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "yaml"
require_relative "validate-skills"

module BrokenFixtureValidation
  Result = Struct.new(:errors, keyword_init: true) do
    def success? = errors.empty?
  end

  REQUIRED_CLASSES = %w[
    admin-api-authorization
    webhook-verification
    xss-input-handling
    secret-config
    marketing-claim
    testimonial
    analytics-consent
    accessibility-labeling
    idempotency
    production-boundaries
  ].freeze
  STATUSES = %w[PASS WARN FAIL BLOCKED NOT_APPLICABLE NOT_VERIFIED].freeze
  SEVERITIES = %w[BLOCKER HIGH MEDIUM LOW INFO].freeze
  PROVIDER_SHAPED_CREDENTIALS = {
    "AWS access key" => /\bAKIA[0-9A-Z]{16}\b/,
    "GitHub token" => /\bgh[pousr]_[A-Za-z0-9]{20,}\b/,
    "Stripe secret key" => /\bsk_(?:live|test)_[A-Za-z0-9]{16,}\b/
  }.freeze

  module_function

  def validate(repository_root:, fixture_root: File.join(repository_root, "fixtures", "broken-nextjs"))
    repository_root = File.expand_path(repository_root)
    fixture_root = File.expand_path(fixture_root)
    errors = []
    manifest = load_manifest(fixture_root, errors)
    validate_manifest(repository_root, fixture_root, manifest, errors) if manifest
    validate_synthetic_credentials(fixture_root, errors)
    Result.new(errors: errors.sort)
  rescue SystemCallError => error
    Result.new(errors: ["fixtures/broken-nextjs: fixture could not be verified: #{error.message}"])
  end

  def load_manifest(fixture_root, errors)
    path = File.join(fixture_root, "expected-findings.yml")
    unless File.file?(path)
      errors << "expected-findings.yml: missing expected-findings manifest"
      return nil
    end

    manifest = YAML.safe_load(File.read(path, encoding: "UTF-8"), permitted_classes: [], permitted_symbols: [], aliases: false)
    unless manifest.is_a?(Hash)
      errors << "expected-findings.yml: manifest must be a mapping"
      return nil
    end
    manifest
  rescue Psych::Exception => error
    errors << "expected-findings.yml: malformed YAML: #{error.message.lines.first.strip}"
    nil
  end

  def validate_manifest(repository_root, fixture_root, manifest, errors)
    errors << "expected-findings.yml: version must be 1" unless manifest["version"] == 1

    required_classes = manifest["requiredClasses"]
    unless required_classes.is_a?(Array) && required_classes.sort == REQUIRED_CLASSES.sort
      errors << "expected-findings.yml: requiredClasses must equal the canonical failure-class list"
    end

    findings = manifest["findings"]
    unless findings.is_a?(Array) && !findings.empty?
      errors << "expected-findings.yml: findings must be a nonempty array"
      return
    end

    canonical_ids = SkillValidation.canonical_check_declarations(repository_root).keys
    seen_cases = {}
    represented_classes = []

    findings.each_with_index do |finding, index|
      label = finding.is_a?(Hash) && finding["case"].is_a?(String) ? finding["case"] : "finding[#{index}]"
      unless finding.is_a?(Hash)
        errors << "#{label}: finding must be a mapping"
        next
      end

      required = %w[case class id file locator status severity rationale]
      missing = required.reject { |key| finding.key?(key) }
      errors << "#{label}: missing required fields: #{missing.join(', ')}" unless missing.empty?

      case_name = finding["case"]
      if !case_name.is_a?(String) || case_name.empty?
        errors << "#{label}: case must be a nonempty string"
      elsif seen_cases.key?(case_name)
        errors << "#{label}: duplicate case name (first used by finding[#{seen_cases[case_name]}])"
      else
        seen_cases[case_name] = index
      end

      failure_class = finding["class"]
      represented_classes << failure_class if failure_class.is_a?(String)
      errors << "#{label}: invalid failure class #{failure_class}" unless REQUIRED_CLASSES.include?(failure_class)

      check_id = finding["id"]
      errors << "#{label}: unknown canonical check ID #{check_id}" unless canonical_ids.include?(check_id)

      status = finding["status"]
      errors << "#{label}: invalid status #{status}" unless STATUSES.include?(status)

      severity = finding["severity"]
      errors << "#{label}: invalid severity #{severity}" unless SEVERITIES.include?(severity)

      rationale = finding["rationale"]
      errors << "#{label}: rationale must be a nonempty string" unless rationale.is_a?(String) && !rationale.strip.empty?

      validate_source(fixture_root, label, finding["file"], finding["locator"], errors)
    end

    missing_classes = REQUIRED_CLASSES - represented_classes
    errors << "expected-findings.yml: findings do not represent classes: #{missing_classes.join(', ')}" unless missing_classes.empty?
  end

  def validate_source(fixture_root, label, relative_file, locator, errors)
    unless relative_file.is_a?(String) && !relative_file.empty?
      errors << "#{label}: file must be a nonempty fixture-relative path"
      return
    end

    source = File.expand_path(relative_file, fixture_root)
    unless source.start_with?(fixture_root + File::SEPARATOR)
      errors << "#{label}: source file escapes fixture root: #{relative_file}"
      return
    end
    unless File.file?(source)
      errors << "#{label}: source file does not exist: #{relative_file}"
      return
    end

    unless locator.is_a?(Hash) && locator["type"] == "marker" && locator["value"].is_a?(String)
      errors << "#{label}: locator must contain type marker and a string value"
      return
    end

    count = File.read(source, encoding: "UTF-8").scan(locator["value"]).length
    errors << "#{label}: source marker must occur exactly once (found #{count}): #{locator['value']} in #{relative_file}" unless count == 1
  end

  def validate_synthetic_credentials(fixture_root, errors)
    Dir.glob(File.join(fixture_root, "**", "*"), File::FNM_DOTMATCH).sort.each do |path|
      next unless File.file?(path)

      content = File.binread(path)
      PROVIDER_SHAPED_CREDENTIALS.each do |provider, pattern|
        if content.match?(pattern)
          relative = Pathname.new(path).relative_path_from(Pathname.new(fixture_root))
          errors << "#{relative}: provider-shaped credential example is prohibited (#{provider})"
        end
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  repository_root = File.expand_path("..", __dir__)
  result = BrokenFixtureValidation.validate(repository_root: repository_root)
  warn result.errors.join("\n") unless result.success?
  exit(result.success? ? 0 : 1)
end
