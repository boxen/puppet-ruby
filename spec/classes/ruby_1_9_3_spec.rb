require 'spec_helper'

describe 'ruby::1_9_3' do
  let(:facts) { default_test_facts }

  it do
    should contain_ruby__version('1.9.3-p484')

    should contain_file('/test/boxen/rbenv/versions/1.9.3').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/1.9.3-p484'
    })
  end
end
