require "spec_helper"

describe "ruby::plugin" do
  let(:facts) { default_test_facts }

  let(:title) { "rbenv-vars" }

  let(:params) do
    {
      :ensure => "v1.2.0",
      :source  => "sstephenson/rbenv-vars",
    }
  end

  it do
    should include_class("ruby")

    should contain_repository("/test/boxen/rbenv/plugins/rbenv-vars").with({
      :ensure  => "v1.2.0",
      :source  => "sstephenson/rbenv-vars",
    })
  end
end
