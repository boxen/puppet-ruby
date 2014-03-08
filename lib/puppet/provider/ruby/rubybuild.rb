require "fileutils"

require 'puppet/util/execution'

Puppet::Type.type(:ruby).provide(:rubybuild) do
  include Puppet::Util::Execution

  def self.rubylist
    @rubylist ||= Dir["/opt/rubies/*"].select do |ruby|
      File.directory?(ruby) && File.executable?("#{ruby}/bin/ruby")
    end.compact
  end

  def self.instances
    rubylist.map do |ruby|
      new({
        :name     => File.basename(ruby),
        :version  => File.basename(ruby),
        :ensure   => :installed,
        :provider => "rubybuild",
      })
    end
  end

  def query
    if self.class.rubylist.member? version
      { :ensure => :installed, :name => version, :version => version}
    else
      { :ensure => :uninstalled, :name => version, :version => version}
    end
  end

  def exists?
    File.executable?("#{prefix}/bin/ruby")
  end

  def create
    if Facter.value(:offline) == "true"
      Puppet.warn("Not installing ruby #{version} as we have no internet")
    else
      execute "#{ruby_build} #{version} #{prefix}", command_opts
    end
  end

  def destroy
    FileUtils.rm_rf prefix
  end

private
  def ruby_build(*args)
    @resource[:ruby_build]
  end

  def command_options
    {
      :custom_environment => @resource[:environment],
      :uid                => @resource[:user],
      :failonfail         => true,
    }
  end

  def version
    @resource[:version]
  end

  def prefix
    "/opt/rubies/#{version}"
  end
end
