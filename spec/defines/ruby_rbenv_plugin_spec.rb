require 'spec_helper'

describe 'ruby::rbenv::plugin' do
  let(:facts) { default_test_facts }

  let(:title) { 'rbenv-vars' }

  let(:default_params) do
    {
      :ensure => 'v1.2.0',
      :source => 'sstephenson/rbenv-vars'
    }
  end

  let(:params) { default_params }

  context "ensure => present" do
    it do
      should contain_class('ruby')
      should contain_file('/test/boxen/rbenv/plugins')
      should contain_repository('/test/boxen/rbenv/plugins/rbenv-vars')
    end
  end

  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent') }
    it do
      should contain_repository('/test/boxen/rbenv/plugins/rbenv-vars').with_ensure('absent')
    end
  end
end
