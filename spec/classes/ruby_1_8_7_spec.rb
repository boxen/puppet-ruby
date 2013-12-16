require 'spec_helper'

describe 'ruby::1_8_7' do
  let(:facts) { default_test_facts }

  it do
    should contain_ruby__version('1.8.7-p358')

    should contain_file('/test/boxen/rbenv/versions/1.8.7').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/1.8.7-p358'
    })
  end
end
