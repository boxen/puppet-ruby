require "spec_helper"

describe "ruby::ree" do
  let(:facts) { default_test_facts }

  it do
    should include_class("ruby")
    should include_class("ruby::ree_1_8_7_2012_02")

    should contain_file("/test/boxen/rbenv/versions/ree").with({
      :ensure => "symlink",
      :force  => true,
      :target => "/test/boxen/rbenv/versions/ree-1.8.7-2012.02"
    })
  end
end
