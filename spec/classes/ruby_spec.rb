require 'spec_helper'

describe 'ruby' do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :default_gems  => [],
      :rbenv_plugins => {},
      :rbenv_version => 'v0.4.0',
      :rbenv_root    => '/test/boxen/rbenv',
      :user          => 'boxenuser'
    }
  end

  let(:params) { default_params }

  it do
    should include_class("ruby::params")

    should contain_repository('/test/boxen/rbenv').with_ensure('v0.4.0')

    should contain_file('/test/boxen/rbenv/versions').with_ensure('directory')
    should contain_file('/test/boxen/rbenv/rbenv.d').with_ensure('directory')
    should contain_file('/test/boxen/rbenv/rbenv.d/install').
      with_ensure('directory')

    should contain_file('/test/boxen/rbenv/rbenv.d/install/00_try_to_download_ruby_version.bash').with({
      :mode   => '0755',
      :source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash'
    })

    should include_class("boxen::config")

    should contain_file('/test/boxen/env.d/rbenv.sh').
      with_source('puppet:///modules/ruby/rbenv.sh')

    should contain_ruby__plugin('ruby-build').with({
      :ensure => 'v20130628',
      :source => 'sstephenson/ruby-build'
    })

    should contain_ruby__plugin('rbenv-gem-rehash').with({
      :ensure => 'v1.0.0',
      :source => 'sstephenson/rbenv-gem-rehash'
    })

    should contain_ruby__plugin('rbenv-default-gems').with({
      :ensure => 'v1.0.0',
      :source => 'sstephenson/rbenv-default-gems'
    })
  end

  context "not darwin" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should_not include_class("boxen::config")

      should_not contain_file('/test/boxen/env.d/rbenv.sh').
        with_source('puppet:///modules/ruby/rbenv.sh')
    end
  end

  context "default_gems" do
    let(:params) do
      default_params.merge(:default_gems => ["bundler ~>1.3", "pry"])
    end

    it do
      should contain_file("/test/boxen/rbenv/default-gems").with({
        :content => "bundler ~>1.3\npry\n"
      })
    end
  end

  context "rbenv plugins" do
    let(:params) do
      default_params.merge(
        :rbenv_plugins => {
          'rbenv-vars' => {
            'ensure' => 'v1.0.0',
            'source' => 'sstephenson/rbenv-vars'
          }
        }
      )
    end

    it do
      should contain_ruby__plugin('rbenv-vars').with({
        :ensure => 'v1.0.0',
        :source => 'sstephenson/rbenv-vars'
      })
    end
  end
end
