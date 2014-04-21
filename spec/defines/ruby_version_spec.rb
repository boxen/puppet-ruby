require 'spec_helper'

describe 'ruby::version' do
  let(:facts) { default_test_facts }
  let(:title) { '1.9.3-p194' }

  context "ensure => present" do
    context "default params" do
      it do
        should include_class('ruby')

        should contain_ruby('1.9.3-p194').with({
          :ensure     => "installed",
          :ruby_build => "/test/boxen/ruby-build/bin/ruby-build",
          :provider   => 'rubybuild',
          :user       => 'testuser',
        })
        
        should contain_ruby_gem('bundler for 1.9.3-p194').with({
          :gem          => "bundler",
          :version      => "~> 1.0",
          :ruby_version => "1.9.3-p194"
        })
      end
    end

    context "when env is default" do
      it do
        should contain_ruby('1.9.3-p194').with_environment({
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
        should contain_ruby('1.9.3-p194').with_environment({
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
      should contain_ruby('1.9.3-p194').with_ensure('absent')
    end
  end
end
