require 'spec_helper'

describe 'ruby::alias' do
  let(:facts) { default_test_facts }

  let(:title) { '2.0.0-github' }

  let(:default_params) { {
    :to => '2.0.0-github1',
    :ensure => 'installed'
  } }
  
  let(:params) { default_params }

  it do
    should contain_ruby('2.0.0-github1')
    should contain_file('/opt/rubies/2.0.0-github').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/rubies/2.0.0-github1'
    }).that_requires('Ruby::Version[2.0.0-github1]')
  end
  
  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent') }
    it do
      should_not contain_ruby('2.0.0-github1')
      should contain_file('/opt/rubies/2.0.0-github').with_ensure('absent')
    end
  end
end
