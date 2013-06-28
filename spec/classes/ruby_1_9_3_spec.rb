require 'spec_helper'

describe 'ruby::1_9_3' do
  let(:facts) { default_test_facts }

  it do
    should include_class('ruby::1_9_3_p448')

    should_not include_class('ruby::1_9_3_p231_tcs_github1')
    should_not include_class('ruby::1_9_3_p231_github1')
    should_not include_class('ruby::1_9_3_p374')
    should_not include_class('ruby::1_9_3_p362')
    should_not include_class('ruby::1_9_3_p194')
    should_not include_class('ruby::1_9_3_p286')
    should_not include_class('ruby::1_9_3_p385')
    should_not include_class('ruby::1_9_3_p392')

    should contain_file('/test/boxen/rbenv/versions/1.9.3').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/1.9.3-p448'
    })
  end
end
