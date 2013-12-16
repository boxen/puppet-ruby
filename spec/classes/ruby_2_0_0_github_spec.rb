require 'spec_helper'

describe 'ruby::2_0_0_github' do
  let(:facts) { default_test_facts }

  it do
    should contain_ruby__version('2.0.0-github6')

    should contain_file('/test/boxen/rbenv/versions/2.0.0-github').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/2.0.0-github6'
    })
  end
end
