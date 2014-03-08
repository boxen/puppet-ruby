require "fileutils"
require "yaml"

Puppet::Type.type(:gemrc).provide(:default) do
  def create
    parsed[@resource[:key].to_sym] = @resource[:value]

    write!
  end

  def destroy
    parsed.delete @resource[:key].to_sym

    write!
  end
  
  def exists?
    if @resource[:ensure] == :absent
      parsed.has_key?(@resource[:name].to_sym)
    else
      parsed.has_key?(@resource[:name].to_sym) \
        && parsed[@resource[:name].to_sym] == @resource[:value]
    end
  end

private
  def write!
    File.open(gemrc, "w") do |f|
      f.write YAML.dump(parsed)
    end
  end

  def parsed
    @parsed ||= YAML.load_file(gemrc)
  rescue Errno::ENOENT
    Hash.new
  end

  def gemrc
    if @resource[:user] == "root"
      "/etc/gemrc"
    else
      if Facter.value(:osfamily) == "Darwin"
        "/Users/#{@resource[:user]}/.gemrc"
      else
        "/home/#{@resource[:user]}/.gemrc"
      end
    end
  end

end
