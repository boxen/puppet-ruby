require 'spec_helper'

describe 'ruby::local' do
  let(:facts) do
    {
      :boxen_home                  => '/opt/boxen',
      :luser                       => 'wfarr',
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
      should include_class('ruby::1_9_3_p194')

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
        :ensure => 'absent'
      }
    end

    it do
      should contain_file('/tmp/.rbenv-version').with_ensure('absent')
      should contain_file('/tmp/.ruby-version').with_ensure('absent')
    end
  end
end
