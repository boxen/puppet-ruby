Puppet::Type.newtype(:rbenv_ruby) do
  @doc = "Manage ruby versions via rbenv"

  validate do
    raise Puppet::Error unless self[:rbenv_root] && self[:environment]
  end

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:version) do
    isnamevar
  end

  newparam(:rbenv_root) do
    validate do |value|
      unless value.is_a? String
        raise Puppet::Error, \
          "Rbenv root must be a string, not a #{value.class.name}"
      end

      unless File.directory?(value)
        raise Puppet::Error, \
          "Rbenv root must exist but doesn't: #{value}"
      end
    end
  end

  newparam(:environment) do
    validate do |value|

      unless value.is_a?(Array)
        raise Puppet::Error, \
          "Environment must be an array, not a #{value.class.name}"
      end

      unless value.all? { |e| e.is_a?(String) }
        raise Puppet::Error, \
          "Environment must be an array of strings, not #{value.inspect}"
      end

      unless value.all? { |e| e =~ /\A\w+=\w+\z/ }
        raise Puppet::Error, \
          "Environment values must be in form KEY=value, not #{value.inspect}"
      end
    end
  end
end
