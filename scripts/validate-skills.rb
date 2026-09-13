#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "yaml"

module SkillValidation
  Result = Struct.new(:errors, keyword_init: true) do
    def success? = errors.empty?
  end

  NAME_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/
  CHECK_ID_PATTERN = /\A[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)+-[0-9]{3}\z/
  FENCE_PATTERN = /^\s*(`{3,}|~{3,})/
  LINK_PATTERN = /(?<!!)\[[^\]\n]*\]\(\s*(?:<([^>]+)>|([^\s)]+))(?:\s+["'][^"']*["'])?\s*\)/

  module_function

  def validate(root)
    root = File.expand_path(root)
    errors = []
    skills_root = File.join(root, "skills")

    unless Dir.exist?(skills_root)
      return Result.new(errors: ["skills: missing required skills directory"])
    end

    skill_directories(skills_root).each do |skill_directory|
      validate_skill(root, skill_directory, errors)
    end
    validate_duplicate_checks(root, skills_root, errors)

    Result.new(errors: errors.sort)
  rescue SystemCallError => error
    Result.new(errors: ["skills: structural input could not be verified: #{error.message}"])
  end

  def canonical_check_declarations(root)
    skills_root = File.join(File.expand_path(root), "skills")
    declarations = Hash.new { |hash, key| hash[key] = [] }

    Dir.glob(File.join(skills_root, "*", "references", "*.md")).sort.each do |path|
      extract_check_declarations(path).each do |check_id|
        declarations[check_id] << relative_path(root, path)
      end
    end

    declarations
  end

  def skill_directories(skills_root)
    Dir.children(skills_root).sort.filter_map do |entry|
      path = File.join(skills_root, entry)
      path if File.directory?(path)
    end
  end

  def validate_skill(root, skill_directory, errors)
    skill_file = File.join(skill_directory, "SKILL.md")
    relative_skill_file = relative_path(root, skill_file)

    unless File.file?(skill_file)
      errors << "#{relative_skill_file}: missing required SKILL.md"
      return
    end

    content = File.read(skill_file, encoding: "UTF-8")
    frontmatter = parse_frontmatter(relative_skill_file, content, errors)
    validate_name(relative_skill_file, File.basename(skill_directory), frontmatter, errors) if frontmatter
    validate_markdown_dependencies(root, skill_directory, relative_skill_file, content, errors)
  rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError => error
    errors << "#{relative_skill_file}: file is not valid UTF-8: #{error.message}"
  end

  def parse_frontmatter(source, content, errors)
    lines = content.lines
    unless lines.first&.match?(/\A---\s*\z/)
      errors << "#{source}: missing opening YAML frontmatter delimiter"
      return nil
    end

    closing_index = lines[1..]&.index { |line| line.match?(/\A---\s*\z/) }
    unless closing_index
      errors << "#{source}: missing closing YAML frontmatter delimiter"
      return nil
    end

    yaml = lines[1, closing_index].join
    parsed = YAML.safe_load(yaml, permitted_classes: [], permitted_symbols: [], aliases: false)
    unless parsed.is_a?(Hash)
      errors << "#{source}: frontmatter must be a mapping"
      return nil
    end

    parsed
  rescue Psych::Exception => error
    errors << "#{source}: malformed YAML frontmatter: #{error.message.lines.first.strip}"
    nil
  end

  def validate_name(source, directory_name, frontmatter, errors)
    name = frontmatter["name"]
    unless name.is_a?(String)
      errors << "#{source}: frontmatter name must be a string"
      return
    end

    errors << "#{source}: name #{name.inspect} does not match directory #{directory_name.inspect}" unless name == directory_name
    errors << "#{source}: name must use lowercase kebab-case" unless NAME_PATTERN.match?(name)
    errors << "#{source}: name exceeds 64 characters (#{name.length})" if name.length > 64
  end

  def validate_markdown_dependencies(root, skill_directory, source, content, errors)
    markdown_lines(content).each_with_index do |line, index|
      without_code = strip_inline_code(line)
      without_code.to_enum(:scan, LINK_PATTERN).each do
        match = Regexp.last_match
        destination = match[1] || match[2]
        validate_link(root, skill_directory, source, destination, index + 1, errors)
      end

      remainder = without_code.gsub(LINK_PATTERN, "")
      if remainder.match?(/\]\([^)]*\.md(?:#[^)]*)?/i)
        errors << "#{source}:#{index + 1}: malformed or unsupported local Markdown dependency"
      end
    end
  end

  def validate_link(root, skill_directory, source, destination, line_number, errors)
    return if destination.start_with?("#")
    return if destination.match?(%r{\Ahttps?://}i)

    path_part = destination.split("#", 2).first
    return unless path_part&.downcase&.end_with?(".md")

    if path_part.start_with?("/") || path_part.match?(/\A[a-z][a-z0-9+.-]*:/i)
      errors << "#{source}:#{line_number}: #{destination.inspect}: local Markdown dependency must be relative"
      return
    end

    resolved = File.expand_path(path_part, skill_directory)
    skill_root = File.expand_path(skill_directory)
    unless resolved == skill_root || resolved.start_with?(skill_root + File::SEPARATOR)
      errors << "#{source}:#{line_number}: #{destination.inspect}: local Markdown dependency escapes skill directory (#{relative_path(root, resolved)})"
      return
    end

    unless File.file?(resolved)
      errors << "#{source}:#{line_number}: #{destination.inspect}: local Markdown dependency does not exist (#{relative_path(root, resolved)})"
    end
  end

  def markdown_lines(content)
    in_fence = false
    fence_character = nil
    fence_length = 0

    content.lines.filter_map do |line|
      if (match = line.match(FENCE_PATTERN))
        marker = match[1]
        if !in_fence
          in_fence = true
          fence_character = marker[0]
          fence_length = marker.length
        elsif marker[0] == fence_character && marker.length >= fence_length
          in_fence = false
        end
        next
      end

      line unless in_fence
    end
  end

  def strip_inline_code(line)
    output = +""
    index = 0

    while index < line.length
      unless line[index] == "`"
        output << line[index]
        index += 1
        next
      end

      run_end = index
      run_end += 1 while line[run_end] == "`"
      marker = "`" * (run_end - index)
      closing = line.index(marker, run_end)
      unless closing
        output << marker
        index = run_end
        next
      end

      output << (" " * (closing + marker.length - index))
      index = closing + marker.length
    end

    output
  end

  def validate_duplicate_checks(root, skills_root, errors)
    canonical_check_declarations(root).each do |check_id, files|
      next unless files.length > 1

      errors << "#{files.first}: duplicate canonical check ID #{check_id}; also declared in #{files.drop(1).join(', ')}"
    end
  end

  def extract_check_declarations(path)
    declarations = []
    in_checks = false

    markdown_lines(File.read(path, encoding: "UTF-8")).each do |line|
      if (heading = line.match(/\A\s*(\#{1,6})\s+(.+?)\s*#*\s*\z/))
        level = heading[1].length
        title = heading[2]
        in_checks = level == 2 && title == "Checks" if level <= 2
        next
      end
      next unless in_checks

      match = line.match(/\A\s*-\s+`([^`]+)`(?:\s|:)/)
      declarations << match[1] if match && CHECK_ID_PATTERN.match?(match[1])
    end

    declarations
  end

  def relative_path(root, path)
    Pathname.new(File.expand_path(path)).relative_path_from(Pathname.new(File.expand_path(root))).to_s
  rescue ArgumentError
    File.expand_path(path)
  end
end

if $PROGRAM_NAME == __FILE__
  result = SkillValidation.validate(File.expand_path("..", __dir__))
  warn result.errors.join("\n") unless result.success?
  exit(result.success? ? 0 : 1)
end
