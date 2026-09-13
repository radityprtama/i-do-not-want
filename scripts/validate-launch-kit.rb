#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require_relative "validate-skills"

module LaunchKitValidation
  Result = Struct.new(:errors, keyword_init: true) do
    def success? = errors.empty?
  end

  REQUIRED_FILES = %w[
    README.md
    short-post.md
    technical-post.md
    channels.md
    measurement.md
    terminal-demo.md
    assets/terminal-demo.svg
  ].freeze
  CONTRIBUTIONS = [
    "false-positive reports",
    "missed findings",
    "fixture contributions",
    "behavioral compatibility reports from other agents"
  ].freeze
  CHANNEL_GUIDANCE = [
    "self-promotion rules",
    "do not post if project sharing is prohibited",
    "disclose project affiliation",
    "cross-community spam",
    "never manufacture"
  ].freeze
  PROHIBITED_CLAIMS = {
    /\bguarantees? security\b/i => "guaranteed security",
    /\bguaranteed secure\b/i => "guaranteed security",
    /\blegally compliant\b/i => "guaranteed legal compliance",
    /\bguarantees? accessibility\b/i => "guaranteed accessibility",
    /\bWCAG compliant\b/i => "guaranteed accessibility",
    /\bguarantees? production readiness\b/i => "guaranteed production readiness",
    /\bdetects? all vulnerabilities\b/i => "complete vulnerability detection"
  }.freeze

  module_function

  def validate(repository_root:, launch_root: File.join(repository_root, "docs", "launch-kit"))
    repository_root = File.expand_path(repository_root)
    launch_root = File.expand_path(launch_root)
    errors = []
    validate_required_files(launch_root, errors)
    return Result.new(errors: errors.sort) unless errors.empty?

    documents = REQUIRED_FILES.to_h do |relative|
      [relative, File.read(File.join(launch_root, relative), encoding: "UTF-8")]
    end
    validate_destinations(documents, errors)
    validate_contributions(documents.fetch("README.md"), errors)
    validate_channels(documents.fetch("channels.md"), errors)
    validate_measurement(documents.fetch("measurement.md"), errors)
    validate_claims(documents, errors)
    validate_terminal_demo(repository_root, documents.fetch("terminal-demo.md"), errors)
    Result.new(errors: errors.sort)
  rescue Psych::Exception => error
    Result.new(errors: ["terminal-demo.md: expected-findings manifest is malformed: #{error.message.lines.first.strip}"])
  rescue SystemCallError => error
    Result.new(errors: ["docs/launch-kit: launch kit could not be verified: #{error.message}"])
  end

  def validate_required_files(launch_root, errors)
    REQUIRED_FILES.each do |relative|
      path = File.join(launch_root, relative)
      errors << "#{relative}: required launch-kit file is missing" unless File.file?(path)
    end
  end

  def validate_destinations(documents, errors)
    install = "npx skills add radityprtama/i-do-not-want"
    github = "https://github.com/radityprtama/i-do-not-want"
    %w[README.md short-post.md technical-post.md].each do |file|
      errors << "#{file}: missing verified install command" unless documents.fetch(file).include?(install)
      errors << "#{file}: missing GitHub destination" unless documents.fetch(file).include?(github)
    end
  end

  def validate_contributions(readme, errors)
    CONTRIBUTIONS.each do |phrase|
      errors << "README.md: missing contribution request: #{phrase}" unless readme.downcase.include?(phrase)
    end
  end

  def validate_channels(channels, errors)
    CHANNEL_GUIDANCE.each do |phrase|
      errors << "channels.md: missing required guidance: #{phrase}" unless channels.downcase.include?(phrase)
    end
    errors << "channels.md: preparation must retain NOT_PUBLISHED states" unless channels.include?("NOT_PUBLISHED")
  end

  def validate_measurement(measurement, errors)
    rows = measurement.lines.grep(/^\| [1-7] \|/)
    if rows.length != 7
      errors << "measurement.md: expected seven unstarted daily measurement rows"
      return
    end

    rows.each do |row|
      values = row.split("|").map(&:strip).reject(&:empty?).drop(1)
      unless values.length == 8 && values.all? { |value| value == "NOT_MEASURED" }
        errors << "measurement.md: metric values must remain NOT_MEASURED during preparation"
        break
      end
    end
  end

  def validate_claims(documents, errors)
    documents.each do |file, content|
      next unless file.end_with?(".md")

      PROHIBITED_CLAIMS.each do |pattern, label|
        errors << "#{file}: prohibited guarantee claim (#{label})" if content.match?(pattern)
      end
    end
  end

  def validate_terminal_demo(repository_root, demo, errors)
    metadata = {
      "case" => demo[/^- Case: `([^`]+)`$/, 1],
      "id" => demo[/^- Check ID: `([^`]+)`$/, 1],
      "file" => demo[/^- Fixture source: `fixtures\/broken-nextjs\/([^`]+)`$/, 1],
      "locator" => demo[/^- Source locator: `([^`]+)`$/, 1]
    }
    metadata.each do |field, value|
      errors << "terminal-demo.md: missing #{field} metadata" unless value
    end
    return if metadata.values.any?(&:nil?)

    manifest_path = File.join(repository_root, "fixtures", "broken-nextjs", "expected-findings.yml")
    manifest = YAML.safe_load(File.read(manifest_path, encoding: "UTF-8"), permitted_classes: [], permitted_symbols: [], aliases: false)
    finding = manifest.fetch("findings").find { |item| item["case"] == metadata["case"] }
    unless finding
      errors << "terminal-demo.md: unknown manifest case #{metadata['case']}"
      return
    end

    errors << "terminal-demo.md: check ID does not match manifest case" unless metadata["id"] == finding["id"]
    errors << "terminal-demo.md: source file does not match manifest case" unless metadata["file"] == finding["file"]
    errors << "terminal-demo.md: locator does not match manifest case" unless metadata["locator"] == finding.dig("locator", "value")

    canonical_ids = SkillValidation.canonical_check_declarations(repository_root).keys
    errors << "terminal-demo.md: check ID is not canonically declared" unless canonical_ids.include?(metadata["id"])

    source_path = File.join(repository_root, "fixtures", "broken-nextjs", metadata["file"])
    unless File.file?(source_path) && File.read(source_path, encoding: "UTF-8").scan(metadata["locator"]).length == 1
      errors << "terminal-demo.md: source locator is not uniquely present in fixture"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  repository_root = File.expand_path("..", __dir__)
  result = LaunchKitValidation.validate(repository_root: repository_root)
  warn result.errors.join("\n") unless result.success?
  exit(result.success? ? 0 : 1)
end
