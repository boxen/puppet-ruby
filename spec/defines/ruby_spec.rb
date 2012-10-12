require 'spec_helper'

describe 'ruby' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  let(:title) { '1.9.3-p194' }

  context "ensure => present" do
    context "default params" do
        it do
        should include_class('rbenv')

        should contain_rbenv_gem('bundler for 1.9.3-p194').with({
          :gem           => 'bundler',
          :version       => '~> 1.2.0',
          :rbenv_root    => '/opt/boxen/rbenv',
          :rbenv_version => '1.9.3-p194'
        })
      end
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_file('/opt/boxen/rbenv/versions/1.9.3-p194').with({
        :ensure => 'absent',
        :force  => true
      })
    end
  end
end
