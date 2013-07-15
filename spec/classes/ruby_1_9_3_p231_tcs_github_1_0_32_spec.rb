require 'spec_helper'

describe 'ruby::1_9_3_p231_tcs_github_1_0_32' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby__definition('1.9.3-p231-tcs-github-1.0.32')
    should contain_ruby__version('1.9.3-p231-tcs-github-1.0.32')
  end
end
