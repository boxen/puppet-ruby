require 'spec_helper'

describe 'ruby::gem' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  let(:title) { 'bundler for 1.9.3-p194' }

  let(:params) do
    {
      :gem     => 'bundler',
      :version => '~> 1.2.0',
      :ruby    => '1.9.3-p194'
    }
  end

  it do
    should include_class('ruby')

    should contain_rbenv_gem('bundler for 1.9.3-p194').with({
      :gem           => 'bundler',
      :version       => '~> 1.2.0',
      :rbenv_root    => '/opt/boxen/rbenv',
      :rbenv_version => '1.9.3-p194'
    })
  end
end
