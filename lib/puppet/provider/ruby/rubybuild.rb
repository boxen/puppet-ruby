require "fileutils"

require 'puppet/util/execution'

Puppet::Type.type(:ruby).provide(:rubybuild) do
  include Puppet::Util::Execution

  def exists?
    File.directory? prefix
    #File.executable?("#{prefix}/bin/ruby")
  end

  def create
    execute "#{ruby_build} #{version} #{prefix}", command_opts
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
    @resource[:prefix]
  end
end
