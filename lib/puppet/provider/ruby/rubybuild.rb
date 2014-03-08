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
      false
    else
      try_to_download_precompiled_ruby or build_ruby
    end
  end

  def destroy
    FileUtils.rm_rf prefix
  end

private
  def try_to_download_precompiled_ruby
    Puppet.debug("Trying to download precompiled ruby for #{version}")
    output = execute "curl --silent --fail #{precompiled_url} | tar xjf - -C /opt/rubies", command_opts.merge(:failonfail => false)
    output.exitstatus == 0
  end

  def build_ruby
    execute "#{ruby_build} #{version} #{prefix}", command_opts
  end

  def precompiled_url
    %W(
      http://
      #{Facter.value(:boxen_s3_host)}
      /
      #{Facter.value(:boxen_s3_bucket)}
      /
      rubies
      /
      #{Facter.value(:operatingsystem)}
      /
      #{os_release}
      /
      #{version}.tar.bz2
    ).join("")
  end

  def os_release
    case Facter.value(:operatingsystem)
    when "Darwin"
      Facter.value(:macosx_productversion_major)
    when "Debian", "Ubuntu"
      Facter.value(:lsbdistcodename)
    else
      Facter.value(:operatingsystem)
    end
  end

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
