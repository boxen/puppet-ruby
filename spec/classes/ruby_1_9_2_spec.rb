require 'spec_helper'

describe 'ruby::1_9_2' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should include_class('ruby::1_9_2_p320')

    should contain_file('/opt/boxen/rbenv/versions/1.9.2').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/boxen/rbenv/versions/1.9.2-p320'
    })
  end
end
