require "spec_helper"

describe "ruby::plugin" do
  let(:facts) { default_test_facts}

  let(:title) { "rbenv-vars" }

  let(:params) do
    {
      :source  => "sstephenson/rbenv-vars",
      :version => "v1.2.0"
    }
  end

  it do
    should include_class("ruby")

    should contain_repository("/test/boxen/rbenv/plugins/rbenv-vars").with({
      :source  => "sstephenson/rbenv-vars",
      :extra   => "-b 'v1.2.0'",
      :require => "File[/test/boxen/rbenv/plugins]"
    })

    should contain_exec("ensure-rbenv-vars-version-v1.2.0").with({
      :command => [
        "git fetch --quiet origin",
        "git reset --hard v1.2.0"
      ].join(" && "),

      :unless  => [
        "git describe --tags --exact-match `git rev-parse HEAD`",
        "grep v1.2.0"
      ].join(" | "),

      :cwd     => "/test/boxen/rbenv/plugins/rbenv-vars",
      :require => "Repository[/test/boxen/rbenv/plugins/rbenv-vars]"
    })
  end
end
