#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "pathname"

module AuditTargetHash
  EXCLUDED_SEGMENTS = %w[.git .cache cache node_modules tmp].freeze

  module_function

  def manifest(root, roots)
    root = File.expand_path(root)
    entries = normalized_files(root, roots).map do |relative_path|
      content_digest = Digest::SHA256.file(File.join(root, relative_path)).hexdigest
      "#{content_digest}  #{relative_path}"
    end
    entries.join("\n") + (entries.empty? ? "" : "\n")
  end

  def digest(root, roots)
    Digest::SHA256.hexdigest(manifest(root, roots))
  end

  def normalized_files(root, roots)
    Array(roots).map(&:to_s).uniq.sort.flat_map do |relative_root|
      absolute_root = File.expand_path(relative_root, root)
      unless absolute_root.start_with?(root + File::SEPARATOR) && File.directory?(absolute_root)
        raise ArgumentError, "hash root must be an existing directory inside the repository: #{relative_root}"
      end

      Dir.glob(File.join(absolute_root, "**", "*"), File::FNM_DOTMATCH).filter_map do |path|
        next unless File.file?(path)

        relative = Pathname.new(path).relative_path_from(Pathname.new(root)).to_s
        next if excluded?(relative)

        relative
      end
    end.uniq.sort
  end

  def excluded?(relative_path)
    segments = relative_path.split(File::SEPARATOR)
    (segments & EXCLUDED_SEGMENTS).any? || relative_path.end_with?(".log")
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    roots = ARGV
    if roots.empty?
      warn "usage: ruby scripts/hash-audit-target.rb ROOT [ROOT ...]"
      exit 2
    end

    repository_root = File.expand_path("..", __dir__)
    puts "roots: #{roots.uniq.sort.join(', ')}"
    puts "sha256: #{AuditTargetHash.digest(repository_root, roots)}"
  rescue ArgumentError => error
    warn error.message
    exit 1
  end
end
