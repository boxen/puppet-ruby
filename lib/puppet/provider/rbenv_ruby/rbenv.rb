require 'puppet/util/execution'

Puppet::Type.type(:rbenv_ruby).provide(:rbenv) do
  include Puppet::Util::Execution

  desc "Default and only provider"

  def rbenv_root
    @rbenv_root ||= @resource[:rbenv_root]
  end

  def default_conf_opts
    @default_conf_opts ||= case @resource[:version]
      when /^1\.8\.7/
        [
          "--disable-tk",
          "--disable-tcl",
          "--disable-tcltk-framework"
        ]
      else
        []
      end
  end

  def conf_opts
    @command_conf_opts ||= (
      default_conf_opts + [@resource[:conf_opts]]
    ).flatten.compact.uniq
  end

  def cc
    @cc ||= case @resource[:version]
      when /^1\.8\.7/, /^1\.9\.2/
        "/usr/local/bin/gcc-4.2"
      else
        "/usr/bin/cc"
      end
  end

  def default_environment
    @default_environment ||= {
      "CC"             => cc,
      "RBENV_ROOT"     => rbenv_root,
      "CONFIGURE_OPTS" => conf_opts,
    }
  end

  def command_environment
    default_environment.merge(@resource[:environment])
  end

  def install_dir
    @install_dir ||= "#{rbenv_root}/versions/#{@resource[:version]}"
  end

  def create
    command = "#{rbenv_root}/rbenv install #{@resource[:version]}"

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
