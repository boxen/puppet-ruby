require 'spec_helper'

describe 'ruby::1_9_2_p290' do
  let(:facts) { default_test_facts }

  it do
    should include_class('gcc')

    should contain_ruby__version('1.9.2-p290').with_env({
      'CC' => '/test/boxen/homebrew/bin/gcc-4.2'
    })
  end

  context "Linux" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should contain_ruby__version('1.9.2-p290').with_env({
        'CC' => 'gcc'
      })
    end
  end
end
