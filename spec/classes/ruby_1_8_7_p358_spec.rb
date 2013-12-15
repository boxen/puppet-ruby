require 'spec_helper'

describe 'ruby::1_8_7_p358' do
  let(:facts) { default_test_facts }
  let(:default_environment) {
    [ "BOXEN_S3_BUCKET=boxen-downloads",
      "BOXEN_S3_HOST=s3.amazonaws.com",
      "CFLAGS=-I/test/boxen/homebrew/include -I/opt/X11/include",
      "LDFLAGS=-L/test/boxen/homebrew/lib -L/opt/X11/lib",
      "RBENV_ROOT=/test/boxen/rbenv"
    ]
  }

  it do
    should include_class('gcc')

    should contain_ruby__version('1.8.7-p358')
    should contain_exec('ruby-install-1.8.7-p358').with_environment(
      (default_environment + ['CC=gcc-4.2', 'CONFIGURE_OPTS=--disable-tk --disable-tcl --disable-tcltk-framework']).sort
    )
  end

  context 'under os x not 10.8' do
    let(:facts) { default_test_facts.merge(:macosx_productversion_major => '10.9') }

    it do
      should contain_exec('ruby-install-1.8.7-p358').with_environment(
        (default_environment + ['CC=gcc-4.8', 'CONFIGURE_OPTS=--disable-tk --disable-tcl --disable-tcltk-framework']).sort
      )
    end
  end

  context "Linux" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should contain_exec('ruby-install-1.8.7-p358').with_environment(
        [ 'CC=gcc',
          'RBENV_ROOT=/usr/local/share/rbenv' ]
      )
    end
  end
end
