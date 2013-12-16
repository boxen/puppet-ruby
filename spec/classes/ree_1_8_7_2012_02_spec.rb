require "spec_helper"

describe "ruby::ree_1_8_7_2012_02" do
  let(:facts) { default_test_facts }

  it do
    should contain_ruby__version('ree-1.8.7-2012.02')
  end
end
