require 'spec_helper'

describe 'ruby' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  it do
    should include_class('boxen::config')
    should include_class('homebrew')

    should contain_file('/opt/boxen/rbenv').with_ensure('directory')
    should contain_file('/opt/boxen/rbenv/versions').with_ensure('directory')
    should contain_file('/opt/boxen/rbenv/rbenv.d').with_ensure('directory')
    should contain_file('/opt/boxen/rbenv/rbenv.d/install').
      with_ensure('directory')

    should contain_file('/opt/boxen/rbenv/rbenv.d/install/00_try_to_download_ruby_version.bash').with({
      :ensure => 'present',
      :mode   => '0755',
      :source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash'
    })

    should contain_package('ruby-build').with_ensure('absent')
    should contain_package('rbenv').with_ensure('absent')

    should contain_file('/opt/boxen/env.d/rbenv.sh').
      with_source('puppet:///modules/ruby/rbenv.sh')
  end
end
