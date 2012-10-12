require 'spec_helper'

describe 'ruby::1-9-3-p194' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby('1.9.3-p194').with({
      :global  => true,
      :require => 'Class[Rbenv]'
    })
  end
end
