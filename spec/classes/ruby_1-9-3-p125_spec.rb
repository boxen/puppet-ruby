require 'spec_helper'

describe 'ruby::1-9-3-p125' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_ruby('1.9.3-p125').with({
      :require => 'Class[Rbenv]'
    })
  end
end
