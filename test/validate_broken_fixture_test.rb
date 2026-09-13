# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "tmpdir"
require_relative "../scripts/validate-broken-fixture"

class ValidateBrokenFixtureTest < Minitest::Test
  REPOSITORY_ROOT = File.expand_path("..", __dir__)
  FIXTURE_ROOT = File.join(REPOSITORY_ROOT, "fixtures", "broken-nextjs")

  def result_for(fixture_root = FIXTURE_ROOT)
    BrokenFixtureValidation.validate(repository_root: REPOSITORY_ROOT, fixture_root: fixture_root)
  end

  def with_fixture_copy
    Dir.mktmpdir do |directory|
      copy = File.join(directory, "broken-nextjs")
      FileUtils.cp_r(FIXTURE_ROOT, copy)
      yield copy
    end
  end

  def mutate_manifest(copy)
    path = File.join(copy, "expected-findings.yml")
    content = File.read(path)
    File.write(path, yield(content))
  end

  def errors_for(copy)
    result_for(copy).errors.join("\n")
  end

  def test_repository_fixture_is_valid
    result = result_for

    assert result.success?, result.errors.join("\n")
    assert_empty result.errors
  end

  def test_unknown_check_id_fails
    with_fixture_copy do |copy|
      mutate_manifest(copy) { |text| text.sub("SEC-AUTHZ-001", "SEC-NOTREAL-999") }

      assert_includes errors_for(copy), "unknown canonical check ID SEC-NOTREAL-999"
    end
  end

  def test_missing_source_file_fails
    with_fixture_copy do |copy|
      mutate_manifest(copy) { |text| text.sub("app/api/admin/users/route.ts", "app/api/admin/missing.ts") }

      assert_includes errors_for(copy), "source file does not exist"
    end
  end

  def test_missing_locator_fails
    with_fixture_copy do |copy|
      mutate_manifest(copy) { |text| text.sub("SEED: unauthenticated-admin-mutation", "SEED: missing-marker") }

      assert_includes errors_for(copy), "source marker must occur exactly once (found 0)"
    end
  end

  def test_duplicate_locator_fails
    with_fixture_copy do |copy|
      path = File.join(copy, "app/api/admin/users/route.ts")
      File.open(path, "a") { |file| file.puts("// SEED: unauthenticated-admin-mutation") }

      assert_includes errors_for(copy), "source marker must occur exactly once (found 2)"
    end
  end

  def test_missing_required_class_fails
    with_fixture_copy do |copy|
      mutate_manifest(copy) { |text| text.sub("  - production-boundaries\n", "") }

      assert_includes errors_for(copy), "requiredClasses must equal the canonical failure-class list"
    end
  end

  def test_invalid_status_fails
    with_fixture_copy do |copy|
      mutate_manifest(copy) { |text| text.sub("status: FAIL", "status: BROKEN") }

      assert_includes errors_for(copy), "invalid status BROKEN"
    end
  end

  def test_invalid_severity_fails
    with_fixture_copy do |copy|
      mutate_manifest(copy) { |text| text.sub("severity: BLOCKER", "severity: URGENT") }

      assert_includes errors_for(copy), "invalid severity URGENT"
    end
  end

  def test_provider_shaped_secret_fails
    with_fixture_copy do |copy|
      path = File.join(copy, "lib/config.ts")
      File.open(path, "a") { |file| file.puts('const badExample = "AKIAABCDEFGHIJKLMNOP";') }

      assert_includes errors_for(copy), "provider-shaped credential example is prohibited"
    end
  end

  def test_validation_does_not_execute_fixture_code
    with_fixture_copy do |copy|
      sentinel = File.join(copy, "execution-sentinel")
      route = File.join(copy, "app/api/admin/users/route.ts")
      File.open(route, "a") { |file| file.puts("// If executed, write #{sentinel}") }

      result_for(copy)

      refute_path_exists sentinel
    end
  end
end
