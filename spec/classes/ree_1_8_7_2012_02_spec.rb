require "spec_helper"

describe "ruby::ree_1_8_7_2012_02" do
  let(:facts) { default_test_facts }

  it do
    should include_class('gcc')
    should include_class('xquartz')

    should contain_ruby__version('ree-1.8.7-2012.02').with({
      :env => {
        'CC'       => '/test/boxen/homebrew/bin/gcc-4.2',
        'CPPFLAGS' => '-I/opt/X11/include'
      }
    })
  end
end
