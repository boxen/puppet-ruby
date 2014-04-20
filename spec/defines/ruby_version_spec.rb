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
        should contain_ruby('1.9.3-p194').with_environment([
          "BOXEN_S3_BUCKET=boxen-downloads",
          "BOXEN_S3_HOST=s3.amazonaws.com",
          "CC=/usr/bin/cc",
          "CFLAGS=-I/test/boxen/homebrew/include -I/opt/X11/include",
          "FROM_HIERA=true",
          "LDFLAGS=-L/test/boxen/homebrew/lib -L/opt/X11/lib",
          "RBENV_ROOT=/test/boxen/rbenv"
        ])
      end
    end

    context "when env is not nil" do
      let(:params) do
        {
          :env => {'SOME_VAR' => "flocka"}
        }
      end

      it do
        should contain_ruby('1.9.3-p194').with_environment([
          "BOXEN_S3_BUCKET=boxen-downloads",
          "BOXEN_S3_HOST=s3.amazonaws.com",
          "CC=/usr/bin/cc",
          "CFLAGS=-I/test/boxen/homebrew/include -I/opt/X11/include",
          "FROM_HIERA=true",
          "LDFLAGS=-L/test/boxen/homebrew/lib -L/opt/X11/lib",
          "RBENV_ROOT=/test/boxen/rbenv",
          "SOME_VAR=flocka"
        ])
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
      should contain_file('/test/boxen/rbenv/versions/1.9.3-p194').with({
        :ensure => 'absent',
        :force  => true
      })
    end
  end
end
