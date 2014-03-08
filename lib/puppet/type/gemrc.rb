Puppet::Type.newtype(:gemrc) do
  @doc = ""

  ensurable do
    newvalue /./ do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
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

  newparam(:value) do
  end

  newparam(:user) do
    defaultto Facter.value(:id)

    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected user to be a String, got a #{v.class.name}"
      end
    end
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end

  autorequire :file do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s

        if Facter.value(:osfamily) == "Darwin"
          a << "/Users/#{user}"
        else
          a << "/home/#{user}/"
        end
      end
    end
  end

end
