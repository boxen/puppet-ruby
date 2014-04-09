Puppet::Type.newtype(:ruby_gem) do
  @doc = ""

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present

    aliasvalue(:installed, :present)
    aliasvalue(:uninstalled, :absent)

    def retrieve
      provider.query[:ensure]
    end

    def insync?(is)
      @should.each { |should|
        case should
        when :present
          return true unless is == :absent
        when :absent
          return true if is == :absent
        when *Array(is)
          return true
        end
      }
      false
    end
  end

  newparam(:name) do
    isnamevar

    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected name to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:gem) do
    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected gem to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:ruby_version) do
    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected ruby_version to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:version) do
    defaultto '>= 0'

    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected version to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:source) do
    defaultto "https://rubygems.org/"

    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected source to be a String, got a #{v.class.name}"
      end
    end
  end

  autorequire :ruby do
    if @parameters.include?(:ruby_version) && ruby_version = @parameters[:ruby_version].to_s
      if ruby_version == "*"
        catalog.resources.find_all { |resource| resource.type == 'Ruby' }
      else
        Array.new.tap do |a|
          a << ruby_version if catalog.resource(:ruby, ruby_version)
        end
      end
    end
  end
end
