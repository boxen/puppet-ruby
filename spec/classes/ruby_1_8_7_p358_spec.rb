require 'spec_helper'

describe 'ruby::1_8_7_p358' do
  let(:facts) { default_test_facts }


  it do
    should include_class('gcc')

    should contain_ruby__version('1.8.7-p358').with_env({
      'CC'             => '/test/boxen/homebrew/bin/gcc-4.2',
      'CONFIGURE_OPTS' => '--disable-tk --disable-tcl --disable-tcltk-framework'
    })
  end

  context 'under os x not 10.8' do
    let(:facts) { default_test_facts.merge(:macosx_productversion_major => '10.9') }

    it do
      should contain_ruby__version('1.8.7-p358').with_env({
        'CC'             => 'gcc-48',
        'CONFIGURE_OPTS' => '--disable-tk --disable-tcl --disable-tcltk-framework'
      })
    end
  end

  context "Linux" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should contain_ruby__version('1.8.7-p358').with_env({
        'CC' => 'gcc',
      })
    end
  end
end
