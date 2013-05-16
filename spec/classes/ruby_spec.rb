require 'spec_helper'

describe 'ruby' do
  let(:facts) { default_test_facts }

  let(:params) do
    {
      :default_gems  => [],
      :rbenv_plugins => {},
      :rbenv_version => 'v0.4.0',
      :root          => '/test/boxen/rbenv',
    }
  end

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

  end

  context "darwin" do
    let(:facts) { default_test_facts.merge(:osfamily => "Darwin") }

    it do
      should include_class("boxen::config")

      should contain_file('/test/boxen/env.d/rbenv.sh').
        with_source('puppet:///modules/ruby/rbenv.sh')
    end
  end
end
