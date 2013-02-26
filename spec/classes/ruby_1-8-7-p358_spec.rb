require 'spec_helper'

describe 'ruby::1-8-7-p358' do
  let(:facts) do
    {
      :boxen_home                  => '/opt/boxen',
      :macosx_productversion_major => '10.8'
    }
  end

  it do
    should contain_ruby__version('1.8.7-p358')
  end
end
