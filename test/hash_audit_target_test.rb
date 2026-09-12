# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "tmpdir"
require_relative "../scripts/hash-audit-target"

class HashAuditTargetTest < Minitest::Test
  def with_tree
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, "skills"))
      FileUtils.mkdir_p(File.join(root, "fixtures/broken-nextjs"))
      File.write(File.join(root, "skills/a.md"), "alpha\n")
      File.write(File.join(root, "fixtures/broken-nextjs/b.md"), "beta\n")
      yield root
    end
  end

  def test_identical_tree_has_stable_digest
    with_tree do |root|
      first = AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
      second = AuditTargetHash.digest(root, %w[fixtures/broken-nextjs skills])

      assert_equal first, second
    end
  end

  def test_content_change_changes_digest
    with_tree do |root|
      before = AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
      File.write(File.join(root, "skills/a.md"), "changed\n")

      refute_equal before, AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
    end
  end

  def test_path_change_changes_digest
    with_tree do |root|
      before = AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
      FileUtils.mv(File.join(root, "skills/a.md"), File.join(root, "skills/renamed.md"))

      refute_equal before, AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
    end
  end

  def test_mutable_paths_are_excluded
    with_tree do |root|
      before = AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
      FileUtils.mkdir_p(File.join(root, "skills/node_modules/pkg"))
      File.write(File.join(root, "skills/node_modules/pkg/index.js"), "mutable")
      FileUtils.mkdir_p(File.join(root, "skills/.cache"))
      File.write(File.join(root, "skills/.cache/result"), "mutable")
      File.write(File.join(root, "skills/run.log"), "mutable")

      assert_equal before, AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
    end
  end

  def test_metadata_change_does_not_change_digest
    with_tree do |root|
      before = AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
      File.utime(Time.now, Time.now, File.join(root, "skills/a.md"))

      assert_equal before, AuditTargetHash.digest(root, %w[skills fixtures/broken-nextjs])
    end
  end

  def test_manifest_names_hashed_files
    with_tree do |root|
      manifest = AuditTargetHash.manifest(root, %w[skills fixtures/broken-nextjs])

      assert_includes manifest, "skills/a.md"
      assert_includes manifest, "fixtures/broken-nextjs/b.md"
    end
  end
end
