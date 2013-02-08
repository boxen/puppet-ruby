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

  def rbenv_gem(command)
    full_command = [
      "sudo -u #{Facter[:luser].value}",
      "PATH=#{path}",
      "RBENV_VERSION=#{@resource[:rbenv_version]}",
      "RBENV_ROOT=#{@resource[:rbenv_root]}",
      "#{@resource[:rbenv_root]}/shims/gem #{command}"
    ].join(" ")

    output = `#{full_command}`
    [output, $?]
  end

  def create
    rbenv_gem "install '#{@resource[:gem]}' -v '#{@resource[:version]}'"
  end

  def destroy
    rbenv_gem "uninstall '#{@resource[:gem]}' -v '#{@resource[:version]}'"
  end

  def exists?
    gem_dir = rbenv_gem("env gemdir").first.strip
    requirement = Gem::Requirement.new(@resource[:version])

    exists = false
    Dir["#{gem_dir}/gems/#{@resource[:gem]}-*"].each do |path|
      gem_with_version = File.basename(path)
      version = gem_with_version.gsub(/^#{@resource[:gem]}-/, '')
      if requirement.satisfied_by? Gem::Version.new(version)
        exists = true
        break
      end
    end

    exists
  end
end
