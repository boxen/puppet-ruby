require 'spec_helper'

describe 'ruby::local' do
  let(:facts) do
    {
      :boxen_home                  => '/opt/boxen',
      :boxen_user                  => 'wfarr',
      :macosx_productversion_major => '10.8'
    }
  end

  let(:title) { '/tmp' }

  context 'ensure => present' do
    let(:params) do
      {
        :version => '1.9.3-p194'
      }
    end

    it do
      should contain_ruby__version('1.9.3-p194')

      should contain_file('/tmp/.rbenv-version').with_ensure('absent')
      should contain_file('/tmp/.ruby-version').with({
        :ensure  => 'present',
        :content => "1.9.3-p194\n",
        :replace => true
      })
    end
  end

  context 'ensure => absent' do
    let(:params) do
      {
        :ensure => 'absent',
      }
    end

    it do
      should contain_file('/tmp/.rbenv-version').with_ensure('absent')
      should contain_file('/tmp/.ruby-version').with_ensure('absent')
    end
  end
end
