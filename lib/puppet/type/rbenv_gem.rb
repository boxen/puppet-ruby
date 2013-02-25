Puppet::Type.newtype(:rbenv_gem) do
  @doc = ""

  autorequire(:rbenv_ruby) do
    "#{self[:rbenv_version]}"
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
end
