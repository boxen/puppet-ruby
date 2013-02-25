require 'spec_helper'

describe 'rbenv_ruby' do
  let(:rbenv_ruby) do
    lambda { |params|
      Puppet::Type.type(:rbenv_ruby).new \
        default_params.merge((params || {}).to_hash)
    }
  end

  context "ensure" do
    let(:default_params) do
      {
        :name        => '2.1.0',
        :version     => '2.1.0',
        :rbenv_root  => '/test/rbenv',
        :environment => []
      }
    end

    before do
      File.stubs(:directory?).returns(true)
    end

    it "accepts present as a value" do
      expect {
        rbenv_ruby.call(:ensure => :present)
      }.not_to raise_error
    end

    it "accepts absent as a value" do
      expect {
        rbenv_ruby.call(:ensure => :absent)
      }.not_to raise_error
    end

    it "rejects other values" do
      expect {
        rbenv_ruby.call(:ensure => :whatever)
      }.to raise_error
    end

    it "defaults to present" do
      rbenv_ruby.call(:version => 'foo')[:ensure].should == :present
    end
  end

  context "version" do
    let(:default_params) do
      {
        :name        => '2.1.0',
        :ensure      => :present,
        :rbenv_root  => '/test/rbenv',
        :environment => []
      }
    end

    before do
      File.stubs(:directory?).returns(true)
    end

    it "defaults to namevar" do
      rbenv_ruby.call(:name => '1')[:version].should == '1'
    end
  end

  context "rbenv_root" do
    let(:default_params) do
      {
        :name        => '2.1.0',
        :ensure      => :present,
        :environment => []
      }
    end

    it "is required" do
      expect {
        rbenv_ruby.call(:version => 'foo')
      }.to raise_error
    end

    it "must be a string" do
      expect {
        rbenv_ruby.call(:rbenv_root => 123)
      }.to raise_error(Puppet::Error, /must be a string/)

      expect {
        rbenv_ruby.call(:rbenv_root => 'foo')
      }.not_to raise_error(Puppet::Error, /must be a string/)
    end

    it "must be a directory" do
      File.stubs(:directory?).with('/nope').returns(false)
      expect {
        rbenv_ruby.call(:rbenv_root => '/nope')
      }.to raise_error(Puppet::Error, /root must exist/)

      File.stubs(:directory?).with('/yep').returns(true)
      expect {
        rbenv_ruby.call(:rbenv_root => '/yep')
      }.not_to raise_error(Puppet::Error, /root must exist/)
    end
  end

  context "environment" do
    let(:default_params) do
      {
        :name        => '2.1.0',
        :ensure      => :present,
        :rbenv_root => '/my/rbenv/root'
      }
    end

    before do
      File.stubs(:directory?).with('/my/rbenv/root').returns(true)
    end

    it "is required" do
      expect {
        rbenv_ruby.call(:version => 'foo')
      }.to raise_error
    end

    it "only takes an array of strings matching the key=value pattern" do
    end
  end
end
