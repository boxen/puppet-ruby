require "rubygems/requirement"
require 'puppet/util/execution'

Puppet::Type.type(:chruby_gem).provide(:rubygems) do
  include Puppet::Util::Execution
  desc ""

  def chruby_gem(command)
    full_command = "#{@resource[:chruby_root]}/bin/chruby-exec #{@resource[:ruby_version]} -- gem #{command}"

    command_opts = {
      :failonfail => true,
      :custom_environment => {
        "RUBIES" => Dir["#{@resource[:chruby_root]}/versions"].join(" "),
      },
      :combine => true
    }

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
    gem_dir = chruby_gem("env gemdir").first.strip
    requirement = Gem::Requirement.new(@resource[:version])

    Dir["#{gem_dir}/gems/#{@resource[:gem]}-*"].each do |path|
      gem_with_version = File.basename(path)

      # skip gems that start with @resource[:gem] to avoid false positives
      # eg. heroku / heroku-api
      next unless gem_with_version =~ /^#{@resource[:gem]}-\d/

      version = gem_with_version.gsub(/^#{@resource[:gem]}-/, '')
      return true if requirement.satisfied_by? Gem::Version.new(version)
    end

    false
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
