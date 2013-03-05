require 'spec_helper'

describe 'ruby::version' do
  let(:facts) do
    {
      :boxen_home                  => '/opt/boxen',
      :luser                       => 'wfarr',
      :macosx_productversion_major => '10.8'
    }
  end

  let(:title) { '1.9.3-p194' }

  context "ensure => present" do
    context "default params" do
      it do
        should include_class('ruby')

        should contain_exec('ruby-install-1.9.3-p194').with({
          :command  => "/opt/boxen/rbenv/bin/rbenv install 1.9.3-p194",
          :cwd      => '/opt/boxen/rbenv/versions',
          :provider => 'shell',
          :timeout  => 0,
          :creates  => '/opt/boxen/rbenv/versions/1.9.3-p194'
        })

        should contain_ruby__gem('bundler for 1.9.3-p194').with({
          :gem     => 'bundler',
          :ruby    => '1.9.3-p194',
          :version => '~> 1.3'
        })

        should contain_ruby__gem('rbenv-autohash for 1.9.3-p194').with({
          :gem     => 'rbenv-autohash',
          :ruby    => '1.9.3-p194'
        })
      end
    end

    context "when conf_opts is nil" do
      it do
        should contain_exec('ruby-install-1.9.3-p194').with_environment([
          "CC=/usr/bin/cc",
          "RBENV_ROOT=/opt/boxen/rbenv"
        ])
      end
    end

    context "when conf_opts is not nil" do
      let(:params) do
        {
          :conf_opts => "flocka"
        }
      end

      it do
        should contain_exec('ruby-install-1.9.3-p194').with_environment([
          "CC=/usr/bin/cc",
          "RBENV_ROOT=/opt/boxen/rbenv",
          "CONFIGURE_OPTS=flocka"
        ])
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
