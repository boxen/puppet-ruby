Puppet::Type.newtype(:gem) do
  @doc = ""

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    newvalue /.+/ do
      provider.destroy if self.retrieve.length > 1
      provider.create

      if self.retrieve == :absent
        :gem_installed
      else
        :gem_changed
      end
    end

    aliasvalue(:installed, :present)
    aliasvalue(:uninstalled, :absent)
    defaultto :present

    def retrieve
      provider.exists?
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
  end

  newparam(:gem) do
  end

  newparam(:ruby_root) do
    validate do |v|
      unless v && !v.empty?
        raise Puppet::ParseError, "invalid ruby_root"
      end
    end
  end

end
