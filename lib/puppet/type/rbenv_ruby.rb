Puppet::Type.newtype(:rbenv_ruby) do
  @doc = "Manage ruby versions via rbenv"

  validate do
    unless :rbenv_root
      raise Puppet:Error, "rbenv_root is a required parameter"
    end
  end

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    aliasvalue(:installed, :present)

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

  newparam(:conf_opts) do
    validate do |value|
      unless value.is_a?(Array)
        raise Puppet::Error, \
          "Environment must be an Array, not a #{value.class.name}"
      end
    end
  end

  newparam(:environment) do
    validate do |value|
      unless value.is_a?(Hash)
        raise Puppet::Error, \
          "Environment must be an Hash, not a #{value.class.name}"
      end
    end
  end
end
