require 'spec_helper'

describe 'ruby::alias' do
  let(:facts) do
    {
      :boxen_home                  => '/test/boxen',
      :boxen_user                  => 'testuser',
      :macosx_productversion_major => '10.8'
    }
  end

  let(:title) { "2.1.0" }
  let(:params) do
    {
      :target => '2.1.0-dev'
    }
  end

  it do
    should contain_file('/test/boxen/rbenv/versions/2.1.0').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/test/boxen/rbenv/versions/2.1.0-dev'
    })
  end
end
