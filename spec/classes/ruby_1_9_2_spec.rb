require 'spec_helper'

describe 'ruby::1_9_2' do
  let(:facts) { default_test_facts }

  it do
    should include_class('ruby::1_9_2_p320')

    should contain_file('/test/boxen/rbenv/versions/1.9.2').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/1.9.2-p320'
    })
  end
end
