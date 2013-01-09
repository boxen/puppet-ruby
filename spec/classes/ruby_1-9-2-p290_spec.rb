require 'spec_helper'

describe 'ruby::1-9-2-p290' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby__version('1.9.2-p290').with({
      :cc        => '/usr/local/bin/gcc-4.2',
      :require   => 'Package[boxen/brews/apple-gcc42]',
    })
  end
end
