require 'spec_helper'

describe 'ruby::1-9-2-p320' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby__version('1.9.2-p320')
  end
end
