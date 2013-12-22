require 'spec_helper'

describe 'ruby::global' do
  let(:facts) { default_test_facts }

  context 'system ruby' do
    let(:params) { {:version => 'system'} }

    it do
      should contain_file('/test/boxen/rbenv/version')
    end
  end

  context 'non-system ruby' do
    let(:params) { {:version => '2.0.0'} }

    it do
      should contain_file('/test/boxen/rbenv/version').that_requires('Ruby::Version[2.0.0]')
    end
  end
end
