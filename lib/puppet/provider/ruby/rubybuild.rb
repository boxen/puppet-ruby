require "fileutils"

require 'puppet/util/execution'

Puppet::Type.type(:ruby).provide(:rubybuild) do
  include Puppet::Util::Execution

  def self.rubylist
    @rubylist ||= Dir["/opt/rubies/*"].map do |ruby|
      if File.directory?(ruby) && File.executable?("#{ruby}/bin/ruby")
        File.basename(ruby)
      end
    end.compact
  end

  def self.instances
    rubylist.map do |ruby|
      new({
        :name     => ruby,
        :version  => ruby,
        :ensure   => :present,
        :provider => "rubybuild",
      })
    end
  end

  def query
    if self.class.rubylist.member?(version)
      { :ensure => :present, :name => version, :version => version}
    else
      { :ensure => :absent,  :name => version, :version => version}
    end
  end

  def create
    destroy if File.directory?(prefix)

    if Facter.value(:offline) == "true"
      if File.exist?("#{cache_path}/ruby-#{version}.tar.gz")
        build_ruby
      else
        raise Puppet::Error, "Can't install ruby because we're offline and the tarball isn't cached"
      end
    else
      build_ruby
    end
  rescue => e
    raise Puppet::Error, "install failed with an error: #{e.message} #{e.backtrace}"
  end

  def destroy
    FileUtils.rm_rf prefix
  end

private

  def build_ruby
    execute "#{ruby_build} #{version} #{prefix}", command_options.merge(:failonfail => true)
  end

  def tmp
    "/tmp/ruby-#{version}.tar.bz2"
  end

  # Keep in sync with same-named function in:
  # https://github.com/boxen/our-boxen/blob/master/script/sync
  def s3_cellar
    homebrew_cellar = "#{Facter.value(:homebrew_root)}/Cellar"
    case homebrew_cellar
    when "/Cellar", "/opt/boxen/homebrew/Cellar" then ""
    when "/usr/local/Cellar" then "default/"
    else "#{Base64.strict_encode64(homebrew_cellar)}/"
    end
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

  def ruby_build
    @resource[:ruby_build]
  end

  def command_options
    {
      :combine            => true,
      :custom_environment => environment,
      :uid                => @resource[:user],
      :failonfail         => true,
    }
  end

  def environment
    return @environment if defined?(@environment)

    @environment = Hash.new

    @environment["RUBY_BUILD_CACHE_PATH"] = cache_path

    @environment.merge!(@resource[:environment])
  end

  def cache_path
    @cache_path ||= if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/cache/rubies"
    else
      "/tmp/rubies"
    end
  end

  def version
    @resource[:version]
  end

  def prefix
    "/opt/rubies/#{version}"
  end
end
