require "test_helper"
require "open3"
require "yaml"

class DeploymentConfigurationTest < ActiveSupport::TestCase
  SHELL_SCRIPTS = Dir[
    Rails.root.join(".github/scripts/*"),
    Rails.root.join("script/*")
  ].select { |path| File.file?(path) }.freeze

  test "deployment shell scripts are valid and executable" do
    SHELL_SCRIPTS.each do |path|
      _stdout, stderr, status = Open3.capture3("bash", "-n", path)

      assert status.success?, "#{path}: #{stderr}"
      assert File.executable?(path), path
    end
  end

  test "workflow YAML parses" do
    Dir[Rails.root.join(".github/workflows/*.yml")].each do |path|
      assert_nothing_raised { YAML.parse_file(path) }
    end
  end

  test "third-party actions are pinned to immutable commits" do
    uses = Dir[Rails.root.join(".github/workflows/*.yml")].flat_map do |path|
      File.read(path).scan(/^\s*uses:\s+([^\s#]+)/).flatten
    end

    assert uses.any?
    uses.each do |action|
      assert_match %r{\A[^@]+@[0-9a-f]{40}\z}, action
    end
  end

  test "SSH requires verified host keys" do
    workflows = Dir[Rails.root.join(".github/workflows/*.yml")].map { |path| File.read(path) }.join
    runner = Rails.root.join(".github/scripts/run-remote").read

    assert_not_includes workflows, "StrictHostKeyChecking=no"
    assert_includes workflows, "VPS_SSH_KNOWN_HOSTS"
    assert_includes runner, "StrictHostKeyChecking=yes"
  end

  test "deployments use immutable event SHAs and reject fork previews" do
    deploy = Rails.root.join(".github/workflows/deploy.yml").read
    preview = Rails.root.join(".github/workflows/preview.yml").read
    scripts = SHELL_SCRIPTS.map { |path| File.read(path) }.join

    assert_includes deploy, "DEPLOY_SHA: ${{ github.sha }}"
    assert_includes preview, "PR_SHA: ${{ github.event.pull_request.head.sha }}"
    assert_includes preview, "head.repo.full_name == github.repository"
    assert_not_includes scripts, "git pull"
    assert_not_includes scripts, "reset --hard"
  end
end
