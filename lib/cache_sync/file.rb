module CacheSync
  class File

    def version
      ::File.read(Rails.root.join('public', 'system', 'weeler-cache-sync'))
    rescue
      nil
    end

    def write version
      ::File.write(Rails.root.join('public', 'system', 'weeler-cache-sync'), version)
    end

  end
end
