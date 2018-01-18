require 'cache_sync/cache'

module CacheSync
  class File < Cache

    MAX_AGE = 1

    @age = nil
    @version = nil

    def read_version
      if @version.nil? || cache_expired?
        @version = ::File.read(Rails.root.join('public', 'system', 'weeler-cache-sync'))
        set_cache_expiration
      end

      @version
    rescue
      nil
    end

    def write_version version
      ::File.write(Rails.root.join('public', 'system', 'weeler-cache-sync'), version)
      set_cache_expiration
    end

    def cache_set_up
      ::File.directory?(Rails.root.join('public', 'system'))
    end

    private

    def cache_expired?
      Time.now.to_f - @age.to_i > MAX_AGE
    end

    def set_cache_expiration
      @age = Time.now.to_f
    end
  end
end
