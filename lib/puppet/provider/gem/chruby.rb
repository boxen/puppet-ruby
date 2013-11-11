require 'puppet/util/execution'

Puppet::Type.type(:gem).provide(:chruby) do
  include Puppet::Util::Execution
  desc ""

  def gem_path
    @gem_path ||= execute("gem env gemdir", default_command_opts).chomp
  end

  def default_command_opts
    @default_command_opts ||= {
      :failonfail         => true,
      :uid                => (Facter.value(:boxen_user) || Facter.value(:id) || "root"),
      :custom_environment => {
        "PATH" => "#{@resource[:ruby_root]}/bin",
      },
      :combine            => true,
    }
  end

  def chruby_gem(command)
    full_command = "gem #{command}"

    command_opts = default_command_opts
    command_opts[:custom_environment].merge!({
      "GEM_PATH" => gem_path,
      "GEM_HOME" => gem_path,
    })

    output = execute(full_command, command_opts)
    [output, $?]
  end

  def create
    chruby_gem "install '#{@resource[:gem]}' -v '#{@resource[:ensure]}'"
  end

  def destroy
    chruby_gem "uninstall '#{@resource[:gem]}' -x -a"
  end

  def query
    h = { :name => @resource[:name], :provider => :chruby }

    all_versions = []

    Dir.chdir "#{gem_path}/gems" do
      all_versions = Dir["#{@resource[:gem]}-*"].map { |g| g.rpartition("-").last }
    end

    if all_versions.any?
      if [:present, :absent].member?(@resource[:ensure])
        h.merge(:ensure => :present)
      else
        if all_versions.length > 1
          h.merge(:ensure => all_versions)
        else
          h.merge(:ensure => all_versions.first)
        end
      end
    else
      h.merge(:ensure => :absent)
    end
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
