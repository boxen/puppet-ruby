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

  it do
    should include_class('ruby')

    should contain_rbenv__version('1.9.3-p194').with({
      :conf_opts   => nil,
      :environment => nil,
      :rbenv_root  => '/opt/boxen/rbenv'
    })

    should contain_ruby__gem('bundler for 1.9.3-p194').with({
      :gem     => 'bundler',
      :ruby    => '1.9.3-p194',
      :version => '~> 1.2.0'
    })

    should contain_ruby__gem('rbenv-autohash for 1.9.3-p194').with({
      :gem  => 'rbenv-autohash',
      :ruby => '1.9.3-p194',
    })
  end
end
