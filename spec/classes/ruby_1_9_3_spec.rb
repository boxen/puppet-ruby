require 'spec_helper'

describe 'ruby::1_9_3' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  it do
    should include_class('ruby::1_9_3_p392')

    should_not include_class('ruby::1_9_3_p231_tcs_github1')
    should_not include_class('ruby::1_9_3_p231_github1')
    should_not include_class('ruby::1_9_3_p374')
    should_not include_class('ruby::1_9_3_p362')
    should_not include_class('ruby::1_9_3_p194')
    should_not include_class('ruby::1_9_3_p286')
    should_not include_class('ruby::1_9_3_p385')

    should contain_file('/opt/boxen/rbenv/versions/1.9.3').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/boxen/rbenv/versions/1.9.3-p392'
    })
  end
end
