require 'spec_helper'

describe 'ruby::jruby_1_7_3' do
  let(:facts) do
    {
      :boxen_home                  => '/test/boxen',
      :boxen_user                  => 'testuser',
      :macosx_productversion_major => '10.8'
    }
  end

  it do
    should include_class('java')
    should include_class('ruby')

    should contain_ruby__version('jruby-1.7.3')#.
      #with_require('[Class[java], Class[ruby]]')
  end
end
