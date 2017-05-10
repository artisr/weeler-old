module CacheSync
  class Cache

    MAX_AGE = 20

    @age = nil
    @version = nil

    def version
      return nil if cache_expired?
      @version ||= read_version
    end

    def write version
      write_version version
      set_cache_expiration
    end

    private

    def read_version
      puts 'You need to implement `version` method on your cache sync'
    end

    def write_version version
      puts 'You need to implement `write`method on your cache sync'
    end

    def cache_expired?
      Time.now.to_i - @age.to_i > MAX_AGE
    end

    def set_cache_expiration
      @age = Time.now.to_i
    end

  end
end
