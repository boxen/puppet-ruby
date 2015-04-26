require "spec_helper"

describe "ruby::rbenv" do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :ensure   => 'v0.4.0',
      :prefix   => '/test/boxen/rbenv',
      :user     => 'testuser',
      :plugins  => {}
    }
  end

  let(:params) { default_params }

  context "ensure => present" do
    context "default params" do
      it do
        should contain_class('ruby')

        should contain_repository('/test/boxen/rbenv').with({
          :ensure => 'v0.4.0',
          :force  => true,
          :source => 'sstephenson/rbenv',
          :user   => 'testuser'
        })

        should contain_file('/test/boxen/rbenv/versions').with({
          :ensure  => 'symlink',
          :force   => true,
          :backup  => false,
          :target  => '/opt/rubies'
        }).that_requires('Repository[/test/boxen/rbenv]')
      end
    end

    context "when plugins is default or empty" do
      it do
        should_not contain_file('/test/boxen/rbenv/plugins')
        should_not contain_ruby__rbenv__plugin('rbenv-vars')
      end
    end

    context "when plugins is not empty" do
      let(:params) { default_params.merge(:plugins => { 'rbenv-vars' => { 'ensure' => 'v1.2.0', 'source' => 'sstephenson/rbenv-vars' } } ) }

      it do
        should contain_file('/test/boxen/rbenv/plugins')
        should contain_ruby__rbenv__plugin('rbenv-vars').with({
          :ensure => 'v1.2.0',
          :source => 'sstephenson/rbenv-vars'
        })
      end
    end
  end

  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent', :plugins => { 'rbenv-vars' => { 'ensure' => 'v1.2.0', 'source' => 'sstephenson/rbenv-vars' } } ) }

    it do
      should contain_repository('/test/boxen/rbenv').with_ensure('absent')
      should_not contain_file('/test/boxen/rbenv/plugins')
      should_not contain_ruby__rbenv__plugin('rbenv-vars')
    end
  end
end
