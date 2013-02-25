require 'puppet/util/execution'

Puppet::Type.type(:rbenv_ruby).provide(:rbenv) do
  include Puppet::Util::Execution

  desc "Default and only provider"

  def rbenv_root
    @rbenv_root ||= @resource[:rbenv_root]
  end

  def default_environment
    {
      "CC"         => "/usr/bin/cc",
      "RBENV_ROOT" => rbenv_root
    }
  end

  def command_environment
    given_environment = @resource[:environment].map do |o|
      o.split('=')
    end.flatten

    given_environment.merge(Hash.new(default_environment))
  end

  def install_dir
    @install_dir ||= "#{rbenv_root}/versions/#{@resource[:version]}"
  end

  def create
    command = [
      "#{rbenv_root}/rbenv",
      "install",
      "#{@resource[:version]}"
    ].join(" ")

    command_opts = {
      :failonfail         => false,
      :uid                => Facter[:boxen_user].value,
      :custom_environment => command_environment
    }

    execute command, command_opts
  end

  def destroy
    FileUtils.rm_rf install_dir
  end

  def exists?
    File.directory? install_dir
  end
end
