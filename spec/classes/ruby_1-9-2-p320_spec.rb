require 'spec_helper'

describe 'ruby::1-9-2-p320' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby('1.9.2-p320').with({
      :cc        => '/usr/local/bin/gcc-4.2',
      :require   => [
        'Package[boxen/brews/apple-gcc42]',
        'Class[Rbenv]'
      ]
    })
  end
end
