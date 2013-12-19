require 'spec_helper'

describe 'ruby::jruby_1_7_6' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby__version('jruby-1.7.6')
  end
end
