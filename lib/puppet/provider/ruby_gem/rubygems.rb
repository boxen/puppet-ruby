require 'puppet/util/execution'

Puppet::Type.type(:ruby_gem).provide(:rubygems) do
  include Puppet::Util::Execution
  desc ""

  def self.gemlist
    return @gemlist if defined?(@gemlist)

    mapping = Hash.new

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
    gems = Array.new

    if gemlist.has_key?(@resource[:ruby_version])
      gems = gemlist[@resource[:ruby_version]].map { |g|
        gem_name, _, gem_version = g.rpartition("-")
        {
          :gem => gem_name,
          :version => gem_version,
        }
      }
    end

    if inst = gems.detect { |g|
        g[:gem] == @resource[:gem] && requirement.satisfied_by?(version(g[:version]))
      }

      {
        :name         => "#{inst[:gem]} for #{inst[:ruby_version]}",
        :gem          => inst[:gem],
        :ensure       => :present,
        :version      => inst[:version],
        :ruby_version => inst[:ruby_version],
      }
    else
      {
        :ensure       => :absent,
        :name         => "#{@resource[:gem]} for #{@resource[:ruby_version]}",
        :gem          => @resource[:gem],
        :ruby_version => @resource[:ruby_version],
      }
    end
  rescue => e
    raise Puppet::Error, "#{e.message}: #{e.backtrace.join('\n')}"
  end

  def create
    if Facter.value(:offline) == "true"
      raise Puppet::Error, "Can't install gems because we're offline"
    else
      gem "install '#{@resource[:gem]}' --version '#{@resource[:version]}' --source '#{@resource[:source]}'"
    end
  end

  def destroy
    gem "uninstall '#{@resource[:gem]}' --version '#{@resource[:version]}'"
  end

private
  def requirement
    Gem::Requirement.new(@resource[:version])
  end

  def version(v)
    Gem::Version.new(v.to_s)
  end

  def gem(command)
    execute "gem #{command}", {
      :combine            => true,
      :failonfail         => true,
      :uid                => user,
      :custom_environment => {
        "PATH" => "/opt/rubies/#{@resource[:ruby_version]}/bin",
      }
    }
  end

  def user
    Facter.value(:boxen_user) || Facter.value(:id)
  end
end
