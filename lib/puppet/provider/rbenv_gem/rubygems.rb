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

    instances.select { |i| i[:name] == @resource[:gem] }.each do |instance|
      return true if requirement.satisfied_by? Gem::Version.new(instance[:version])
    end

    false
  end

  def instances
    self.instances
  end

  def self.instances
    instance_cache[@resource[:rbenv_version]]
  end

  def self.instance_cache
    if @cache.has_key? @resource[:rbenv_version]
      @cache[@resource[:rbenv_version]]
    else
      gems = Dir["#{gemdir}/gems/*.gem"].map do |path|
        n, v = File.basename(path).rpartition("-")
        { :name => n, :version => v }
      end
    end
  end
end
