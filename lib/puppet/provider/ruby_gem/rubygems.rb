require 'puppet/util/execution'

Puppet::Type.type(:ruby_gem).provide(:rubygems) do
  include Puppet::Util::Execution
  desc ""

  def self.ruby_versions
    Dir["/opt/rubies/*"].map do |ruby|
      File.basename(ruby)
    end
  end

  def ruby_versions
    self.class.ruby_versions
  end

  def self.gemlist
    return @gemlist if defined?(@gemlist)

    mapping = Hash.new { |h,k| h[k] = {} }

    Dir["/opt/rubies/*"].each do |ruby|
      v = File.basename(ruby)
      mapping[v] = Array.new

      Dir["#{ruby}/lib/ruby/gems/*/gems/*"].each do |g|
        mapping[v] << File.basename(g)
      end
    end

    @gemlist = mapping
  end

  def self.instances
    return @instances if defined?(@instances)

    all_gems = Array.new

    gemlist.each do |r, gems|

      gems.each do |g|

        gem_name, _, gem_version = g.rpartition("-")

        all_gems << new({
          :name         => "#{gem_name} for #{r}",
          :gem          => gem_name,
          :ensure       => :installed,
          :version      => gem_version,
          :ruby_version => r,
          :provider     => :rubygems,
        })
      end
    end

    @instances = all_gems
  end

  def gemlist
    self.class.gemlist
  end

  def instances
    self.class.instances
  end

  def query
    if @resource[:ruby_version] == "*"
      installed = ruby_versions.all? { |r| installed_for? r }
    else
      installed = installed_for? @resource[:ruby_version]
    end
    {
      :name         => "#{@resource[:gem]} for all rubies",
      :ensure       => installed ? :present : :absent,
      :version      => @resource[:version],
      :gem          => @resource[:gem],
      :ruby_version => @resource[:ruby_version],
    }

  rescue => e
    raise Puppet::Error, "#{e.message}: #{e.backtrace.join('\n')}"
  end

  def create
    if Facter.value(:offline) == "true"
      raise Puppet::Error, "Can't install gems because we're offline"
    else
      if @resource[:ruby_version] == "*"
        target_versions = ruby_versions
      else
        target_versions = [@resource[:ruby_version]]
      end
      target_versions.reject { |r| installed_for? r }.each do |ruby|
        gem "install '#{@resource[:gem]}' --version '#{@resource[:version]}' --source '#{@resource[:source]}' --no-rdoc --no-ri", ruby
      end
    end
  rescue => e
    raise Puppet::Error, "#{e.message}: #{e.backtrace.join("\n")}"
  end

  def destroy
    if @resource[:ruby_version] == "*"
      target_versions = ruby_versions
    else
      target_versions = [@resource[:ruby_version]]
    end
    target_versions.select { |r| installed_for? r }.each do |ruby|
      gem "uninstall '#{@resource[:gem]}' --version '#{@resource[:version]}'", ruby
    end
  end

private
  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def self.execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  def gem(command, ruby_version)
    bindir = "/opt/rubies/#{ruby_version}/bin"
    execute "#{bindir}/gem #{command} --verbose", {
      :combine            => true,
      :failonfail         => true,
      :uid                => user,
      :override_locale    => false,
      :custom_environment => {
        "PATH" => env_path(bindir),
        "GEM_PATH" => nil,
        "LANG" => "en_US.UTF-8"
      }
    }
  end

  def user
    Facter.value(:boxen_user) || Facter.value(:id)
  end

  def version(v)
    Gem::Version.new(v)
  end

  def requirement
    Gem::Requirement.new(@resource[:version])
  end

  def installed_for?(ruby_version)
    installed_gems[ruby_version].any? { |g|
      g[:gem] == @resource[:gem] \
        && requirement.satisfied_by?(version(g[:version])) \
        && g[:ruby_version] == ruby_version
    }
  end

  def installed_gems
    @installed_gems ||= Hash.new do |installed_gems, ruby_version|
      installed_gems[ruby_version] = gemlist[ruby_version].map { |g|
        gem_name, _, gem_version = g.rpartition("-")
        {
          :gem          => gem_name,
          :version      => gem_version,
          :ruby_version => ruby_version,
        }
      }
    end
  end

  def env_path(bindir)
    [bindir,
     "#{Facter.value(:boxen_home)}/bin",
     "/usr/bin", "/bin", "/usr/sbin", "/sbin"].join(':')
  end
end
