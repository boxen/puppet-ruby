require 'spec_helper'

describe 'ruby::1-9-3' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  it do
    should include_class('rbenv')
    should include_class('ruby::1-9-3-p194')

    should contain_file('/opt/boxen/rbenv/versions/1.9.3').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/boxen/rbenv/versions/1.9.3-p194'
    })
  end
end
