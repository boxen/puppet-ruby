Puppet::Type.newtype(:rbenv_gem) do
  @doc = ""

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    isnamevar
  end

  newparam(:gem) do
  end

  newparam(:rbenv_version) do
  end

  newparam(:version) do
    defaultto '>= 0'
  end

  newparam(:rbenv_root) do
  end

  autorequire(:exec) do
    "ruby-install-#{self[:rbenv_version]}"
  end
end
