require 'spec_helper'

describe 'ruby::jruby' do
  let(:facts) do
    {
      :boxen_home                  => '/test/boxen',
      :boxen_user                  => 'testuser',
      :macosx_productversion_major => '10.8'
    }
  end

  it do
    should include_class('ruby')
    should include_class('ruby::jruby_1_7_3')

    should contain_ruby__alias('jruby').with_target('jruby-1.7.3')
  end
end
