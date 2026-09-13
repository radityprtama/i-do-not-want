# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "tmpdir"
require_relative "../scripts/validate-skills"

class ValidateSkillsTest < Minitest::Test
  def with_repository
    Dir.mktmpdir do |root|
      yield root
    end
  end

  def write(path, content)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end

  def skill(root, directory: "example-skill", name: directory, body: "# Example\n")
    write(
      File.join(root, "skills", directory, "SKILL.md"),
      "---\nname: #{name}\ndescription: Test skill.\nlicense: MIT\n---\n\n#{body}"
    )
  end

  def errors_for(root)
    SkillValidation.validate(root).errors.join("\n")
  end

  def test_valid_skill
    with_repository do |root|
      skill(root, body: "Read [details](references/details.md).\n")
      write(File.join(root, "skills/example-skill/references/details.md"), "# Details\n")

      result = SkillValidation.validate(root)

      assert result.success?, result.errors.join("\n")
      assert_empty result.errors
    end
  end

  def test_missing_skill_file
    with_repository do |root|
      FileUtils.mkdir_p(File.join(root, "skills/example-skill"))

      assert_includes errors_for(root), "skills/example-skill/SKILL.md: missing required SKILL.md"
    end
  end

  def test_malformed_yaml
    with_repository do |root|
      write(File.join(root, "skills/example-skill/SKILL.md"), "---\nname: [broken\n---\n")

      error = errors_for(root)
      assert_includes error, "skills/example-skill/SKILL.md"
      assert_includes error, "malformed YAML frontmatter"
    end
  end

  def test_non_mapping_frontmatter
    with_repository do |root|
      write(File.join(root, "skills/example-skill/SKILL.md"), "---\n- example-skill\n---\n")

      assert_includes errors_for(root), "frontmatter must be a mapping"
    end
  end

  def test_name_must_match_directory
    with_repository do |root|
      skill(root, directory: "example-skill", name: "other-skill")

      assert_includes errors_for(root), "name \"other-skill\" does not match directory \"example-skill\""
    end
  end

  def test_name_must_be_kebab_case
    with_repository do |root|
      skill(root, directory: "Bad--Name", name: "Bad--Name")

      assert_includes errors_for(root), "name must use lowercase kebab-case"
    end
  end

  def test_name_must_not_exceed_64_characters
    with_repository do |root|
      long_name = "a" * 65
      skill(root, directory: long_name, name: long_name)

      assert_includes errors_for(root), "name exceeds 64 characters"
    end
  end

  def test_missing_local_markdown_dependency
    with_repository do |root|
      skill(root, body: "Read [missing](references/missing.md#details).\n")

      error = errors_for(root)
      assert_includes error, "skills/example-skill/SKILL.md"
      assert_includes error, "references/missing.md#details"
      assert_includes error, "local Markdown dependency does not exist"
    end
  end

  def test_ignores_external_markdown_url
    with_repository do |root|
      skill(root, body: "Read [remote](https://example.com/guide.md).\n")

      assert SkillValidation.validate(root).success?
    end
  end

  def test_ignores_anchor_only_link
    with_repository do |root|
      skill(root, body: "Read [section](#details).\n")

      assert SkillValidation.validate(root).success?
    end
  end

  def test_ignores_fenced_code
    with_repository do |root|
      skill(root, body: "```markdown\n[missing](references/missing.md)\n```\n")

      assert SkillValidation.validate(root).success?
    end
  end

  def test_ignores_inline_code
    with_repository do |root|
      skill(root, body: "Example: `[missing](references/missing.md)`.\n")

      assert SkillValidation.validate(root).success?
    end
  end

  def test_duplicate_canonical_check_declaration
    with_repository do |root|
      skill(root)
      declaration = "## Checks\n- `SEC-TEST-001` HIGH: First.\n"
      write(File.join(root, "skills/example-skill/references/one.md"), declaration)
      write(File.join(root, "skills/example-skill/references/two.md"), declaration)

      error = errors_for(root)
      assert_includes error, "duplicate canonical check ID SEC-TEST-001"
      assert_includes error, "references/one.md"
      assert_includes error, "references/two.md"
    end
  end

  def test_repeated_non_declaration_id_reference_is_allowed
    with_repository do |root|
      skill(root)
      write(
        File.join(root, "skills/example-skill/references/checks.md"),
        "## Checks\n- `SEC-TEST-001` HIGH: Declared.\n\n## Example\n`SEC-TEST-001` appears again.\n"
      )
      write(File.join(root, "examples/report.md"), "Finding: `SEC-TEST-001`.\n")

      assert SkillValidation.validate(root).success?
    end
  end
end
