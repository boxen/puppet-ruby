require 'puppet/util/execution'

Puppet::Type.type(:rbenv_gem).provide(:rubygems) do
  include Puppet::Util::Execution
  desc ""

  def path
    [
      "#{@resource[:rbenv_root]}/bin",
      "#{@resource[:rbenv_root]}/plugins/ruby-build/bin",
      "#{@resource[:rbenv_root]}/shims",
      "#{Facter[:boxen_home].value}/homebrew/bin",
      "$PATH"
    ].join(':')
  end

  def self.rbenv_gem(command)
    full_command = [
      "sudo -u #{Facter[:boxen_user].value}",
      "PATH=#{path}",
      "RBENV_VERSION=#{@resource[:rbenv_version]}",
      "RBENV_ROOT=#{@resource[:rbenv_root]}",
      "#{@resource[:rbenv_root]}/shims/gem #{command}"
    ].join(" ")

    output = `#{full_command}`
    [output, $?]
  end

  def self.gemdir
    rbenv_gem("env gemdir").first.strip
  end

  def rbenv_gem(command)
    self.class.rbenv_gem(command)
  end

  def gemdir
    self.gemdir
  end

  def create
    rbenv_gem "install '#{@resource[:gem]}' -v '#{@resource[:version]}'"
  end

  def destroy
    rbenv_gem "uninstall '#{@resource[:gem]}' -v '#{@resource[:version]}'"
  end

  def exists?
    requirement = Gem::Requirement.new(@resource[:version])

    Dir["#{gemdir}/gems/#{@resource[:gem]}-*"].each do |path|
      gem_with_version = File.basename(path)

      # skip gems that start with @resource[:gem] to avoid false positives
      # eg. heroku / heroku-api
      next unless gem_with_version =~ /^#{@resource[:gem]}-\d/

      version = gem_with_version.gsub(/^#{@resource[:gem]}-/, '')
      return true if requirement.satisfied_by? Gem::Version.new(version)
    end

    false
  end

  def self.instances
    instance_cache[@resource[:rbenv_version]]
  end

  def self.instance_cache
    if @cache.has_key? @resource[:rbenv_version]
      @cache[@resource[:rbenv_version]]
    else
      @cache[@resource[:rbenv_version]] = Dir["#{gemdir}/gems/*.gem"].map do |g|
        {
          :name    => File.basename(g).split("-").first,
          :version => File.basename(g).split("-").last
        }
      end
    end
  end
end
