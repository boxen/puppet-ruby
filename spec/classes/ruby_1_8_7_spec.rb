require 'spec_helper'

describe 'ruby::1_8_7' do
  let(:facts) do
    {
      :boxen_home                  => '/opt/boxen',
      :macosx_productversion_major => '10.8'
    }
  end

  it do
    should include_class('ruby::1_8_7_p358')

    should contain_file('/opt/boxen/rbenv/versions/1.8.7').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/boxen/rbenv/versions/1.8.7-p358'
    })
  end
end
