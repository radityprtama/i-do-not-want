# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "tmpdir"
require_relative "../scripts/validate-launch-kit"

class ValidateLaunchKitTest < Minitest::Test
  REPOSITORY_ROOT = File.expand_path("..", __dir__)
  LAUNCH_ROOT = File.join(REPOSITORY_ROOT, "docs", "launch-kit")

  def with_launch_copy
    Dir.mktmpdir do |directory|
      copy = File.join(directory, "launch-kit")
      FileUtils.cp_r(LAUNCH_ROOT, copy)
      yield copy
    end
  end

  def errors_for(launch_root = LAUNCH_ROOT)
    LaunchKitValidation.validate(repository_root: REPOSITORY_ROOT, launch_root: launch_root).errors.join("\n")
  end

  def test_repository_launch_kit_is_valid
    result = LaunchKitValidation.validate(repository_root: REPOSITORY_ROOT)

    assert result.success?, result.errors.join("\n")
    assert_empty result.errors
  end

  def test_missing_required_file_fails
    with_launch_copy do |copy|
      FileUtils.rm(File.join(copy, "channels.md"))

      assert_includes errors_for(copy), "channels.md: required launch-kit file is missing"
    end
  end

  def test_unknown_demo_case_fails
    with_launch_copy do |copy|
      path = File.join(copy, "terminal-demo.md")
      File.write(path, File.read(path).sub("unauthenticated-admin-mutation", "missing-case"))

      assert_includes errors_for(copy), "terminal-demo.md: unknown manifest case missing-case"
    end
  end

  def test_unknown_demo_check_id_fails
    with_launch_copy do |copy|
      path = File.join(copy, "terminal-demo.md")
      File.write(path, File.read(path).sub("SEC-AUTHZ-001", "SEC-NOTREAL-999"))

      assert_includes errors_for(copy), "terminal-demo.md: check ID does not match manifest case"
    end
  end

  def test_missing_demo_source_locator_fails
    with_launch_copy do |copy|
      path = File.join(copy, "terminal-demo.md")
      File.write(path, File.read(path).sub("SEED: unauthenticated-admin-mutation", "SEED: missing"))

      assert_includes errors_for(copy), "terminal-demo.md: locator does not match manifest case"
    end
  end

  def test_prohibited_guarantee_claim_fails
    with_launch_copy do |copy|
      path = File.join(copy, "short-post.md")
      File.open(path, "a") { |file| file.puts("This guarantees security for every app.") }

      assert_includes errors_for(copy), "short-post.md: prohibited guarantee claim"
    end
  end

  def test_missing_contribution_request_fails
    with_launch_copy do |copy|
      path = File.join(copy, "README.md")
      File.write(path, File.read(path).sub("missed findings", "omissions"))

      assert_includes errors_for(copy), "README.md: missing contribution request: missed findings"
    end
  end

  def test_missing_channel_rules_guidance_fails
    with_launch_copy do |copy|
      path = File.join(copy, "channels.md")
      File.write(path, File.read(path).sub("self-promotion rules", "posting guidance"))

      assert_includes errors_for(copy), "channels.md: missing required guidance: self-promotion rules"
    end
  end

  def test_populated_measurement_result_fails
    with_launch_copy do |copy|
      path = File.join(copy, "measurement.md")
      File.write(path, File.read(path).sub("| 1 | NOT_MEASURED", "| 1 | 42"))

      assert_includes errors_for(copy), "measurement.md: metric values must remain NOT_MEASURED during preparation"
    end
  end
end
