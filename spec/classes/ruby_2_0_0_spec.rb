require 'spec_helper'

describe 'ruby::2_0_0' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  it do
    should include_class('ruby::2_0_0_p0')

    should contain_file('/opt/boxen/rbenv/versions/2.0.0').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/boxen/rbenv/versions/2.0.0-p0'
    })
  end
end
