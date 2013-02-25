Puppet::Type.newtype(:rbenv_ruby) do
  @doc = "Manage ruby versions via rbenv"

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
      File.directory?(value)
    end
  end

  newparam(:configure_opts) do
    validate do |value|
      value.is_a? Array
    end
  end
end
