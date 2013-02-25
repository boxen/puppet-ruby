require 'puppet/util/execution'

Puppet::Type.type(:rbenv_ruby).provide(:rbenv) do
  include Puppet::Util::Execution

  desc "Default and only provider"

  def default_configure_opts
    {
      "CC"         => "/usr/bin/cc",
      "RBENV_ROOT" => "#{@resource[:rbenv_root]}"
    }
  end

  def configure_opts
    supplied_conf_opts = @resource[:conf_opts].map do |o|
      o.split('=')
    end.flatten

    default_config_opts.merge(Hash.new(supplied_conf_opts))
  end

  def install_dir
    "#{@resource[:rbenv_root]}/versions/#{@resource[:version]}"
  end

  def create
    command = [
      "#{@resource[:rbenv_root]}/rbenv",
      "install",
      "#{@resource[:version]}"
    ].join(" ")

    command_opts = {
      :failonfail         => false,
      :uid                => Facter[:boxen_user].value,
      :custom_environment => configure_opts
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
