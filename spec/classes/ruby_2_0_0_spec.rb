require 'spec_helper'

describe 'ruby::2_0_0' do
  let(:facts) { default_test_facts }

  it do
    should include_class('ruby::2_0_0_p247')

    should contain_file('/test/boxen/rbenv/versions/2.0.0').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/2.0.0-p247'
    })
  end
end
