require 'spec_helper'

describe 'ruby::1_9_2_p320' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should include_class('gcc')

    should contain_ruby__version('1.9.2-p320').with_env({
      'CC' => '/opt/boxen/homebrew/bin/gcc-4.2',
    })
  end
end
