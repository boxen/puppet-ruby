require 'spec_helper'

describe 'ruby::jruby' do
  let(:facts) { default_test_facts }

  it do
    should include_class('ruby::jruby_1_7_6')

    should contain_file('/test/boxen/rbenv/versions/jruby').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/jruby-1.7.6'
    })
  end
end
