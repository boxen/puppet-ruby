require 'puppet/util/execution'

Puppet::Type.type(:chruby_gem).provide(:rubygems) do
  include Puppet::Util::Execution
  desc ""

  def gem_path
    @gem_path ||= chruby_gem("env gemdir").first.chomp
  end

  def path
    @paths = %W(
      #{@resource[:chruby_root]}/bin
      #{@resource[:chruby_root]}/versions/#{@resource[:ruby_version]}/bin
    )
  end

  def chruby_gem(command)
    full_command = "gem #{command}"

    command_opts = {
      :failonfail         => true,
      :custom_environment => {
        "PATH" => @path,
      },
      :combine            => true,
    }

    if defined?(@gem_path)
      command_opts[:custom_environment].merge!({
        "GEM_PATH" => @gem_path,
        "GEM_HOME" => @gem_path,
      })
    end

    if uid = (Facter.value(:boxen_user) || Facter.value(:id))
      command_opts.merge!(:uid => uid)
    end

    output = execute(full_command, command_opts)
    [output, $?]
  end

  def create
    chruby_gem "install '#{@resource[:gem]}' -v '#{@resource[:version]}'"
  end

  def destroy
    chruby_gem "uninstall '#{@resource[:gem]}' -v '#{@resource[:version]}'"
  end

  def exists?
    File.directory? "#{gem_path}/gems/#{@resource[:gem]}-#{@resource[:version]}"
  end

private
  def execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  def self.execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end
end
