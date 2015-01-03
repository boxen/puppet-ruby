require 'spec_helper'

describe 'ruby::version' do
  let(:facts) { default_test_facts }
  let(:title) { '2.2.0' }

  context "ensure => present" do
    context "default params" do
      it do
        should contain_class('ruby')

        should contain_ruby('2.2.0').with({
          :ensure     => "installed",
          :ruby_build => "/test/boxen/ruby-build/bin/ruby-build",
          :provider   => 'rubybuild',
          :user       => 'testuser',
        })
      end
    end

    context "when env is default" do
      it do
        should contain_ruby('2.2.0').with_environment({
          "CC" => "/usr/bin/cc",
          "FROM_HIERA" => "true",
        })
      end
    end

    context "when env is not nil" do
      let(:params) do
        {
          :env => {'SOME_VAR' => "flocka"}
        }
      end

      it do
        should contain_ruby('2.2.0').with_environment({
          "CC" => "/usr/bin/cc",
          "FROM_HIERA" => "true",
          "SOME_VAR" => "flocka"
        })
      end
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_ruby('2.2.0').with_ensure('absent')
    end
  end
end
