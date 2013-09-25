require 'spec_helper'

describe 'ruby::2_0_0_github3' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby__definition('2.0.0-github3')
    should contain_ruby__version('2.0.0-github3')
  end
end
