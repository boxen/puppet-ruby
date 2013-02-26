require 'spec_helper'

describe 'ruby::1_9_2_p320' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby__version('1.9.2-p320').with({
      :cc        => '/usr/local/bin/gcc-4.2',
    })
  end
end
