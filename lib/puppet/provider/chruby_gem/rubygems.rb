require "puppet/provider/package"
require "puppet/util/execution"

Puppet::Type.type(:package).provide :chruby_gem, :parent => :gem, :source => :gem do
  include Puppet::Util::Execution
  desc ""

  def ruby_version
    @ruby_version ||= @resource[:install_options].first["RUBY_VERSION"]
  end

  def chruby_root
    @chruby_root ||= @resource[:install_options].first["CHRUBY_ROOT"]
  end

  def major_ruby_version
    @major_ruby_version ||= ruby_version.match(/^\d\.\d\.\d/)[0]
  end

  def chruby_gem(command)
    full_command = "#{chruby_root}/versions/#{ruby_version}/bin/gem #{command}"

    command_opts = {
      :failonfail => true,
      :uid        => Facter[:boxen_user].value,
      :custom_environment => {
        "PATH"     => "#{@resource[:chruby_root]}/bin:/usr/bin:/bin",
        "GEM_HOME" => "/Users/#{Facter[:boxen_user].value}/.gem/ruby/#{major_ruby_version}",
        "GEM_PATH" => "/Users/#{Facter[:boxen_user].value}/.gem/ruby/#{major_ruby_version}",
        "HOME"     => "/Users/#{Facter[:boxen_user].value}",
      },
      :combine    => true,
    }

    output = execute(full_command, command_opts)
    [output, $?]
  end

  def install(useversion = true)
    if useversion
      chruby_gem "install '#{@resource[:name]}' -v '#{@resource[:ensure]}'"
    else
      chruby_gem "install '#{@resource[:name]}'"
    end
  end

  def uninstall
    chruby_gem "uninstall '#{@resource[:gem]}' -v '#{@resource[:ensure]}'"
  end

  def query
    self.class.instances[major_ruby_version].select { |g| g[:name] == @resource[:gem] }.first
  end

  def latest
    query[:ensure][0]
  end

  # {
  #   "1.9.3" => [
  #     { :name => "bundler", :version => ["1.4.0.rc.1", "1.3.1"] },
  #   ]
  # }
  def self.instances(justme = false)
    @instances ||= build_instances
  end

  def self.build_instances
    @instances = {}

    Dir["#{gemdir}/*"].each do |path|
      major_ruby_version = File.basename(path)

      @instances[major_ruby_version] ||= []

      Dir["#{gemdir}/#{major_ruby_version}/gems/*"].each do |gempath|
        gem_with_version = File.basename(gempath)

        gem_name, _, gem_version = gem_with_version.rpartition("-")

        if the_gem = @instances[major_ruby_version].select { |g| g[:name] == gem_name }.first
          the_gem[:versions] << gem_version
        else
          @instances[major_ruby_version] << {
            :name     => gem_name,
            :version  => [gem_version],
            :provider => :chruby_gem,
          }
        end
      end
    end

    @instances
  end

  def self.gemdir
    "/Users/#{Facter[:boxen_user].value}/.gem/ruby"
  end


  # compatibility shims omg
  def self.gemlist(options)
    instances
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
