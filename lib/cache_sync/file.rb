require 'cache_sync/cache'

module CacheSync
  class File < Cache

    def read_version
      ::File.read(Rails.root.join('public', 'system', 'weeler-cache-sync'))
    rescue
      nil
    end

    def write_version version
      ::File.write(Rails.root.join('public', 'system', 'weeler-cache-sync'), version)
    end

  end
end
