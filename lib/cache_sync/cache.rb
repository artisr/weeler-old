module CacheSync
  class Cache

    def version
      read_version
    end

    def write version
      write_version version
    end

    def implemented?
      cache_set_up
    end

    protected

    def read_version
      puts 'You need to implement `version` method on your cache sync'
    end

    def write_version version
      puts 'You need to implement `write` method on your cache sync'
    end

    def cache_set_up
      puts 'You need to implement `cache_set_up` method on your cache sync'
      return false
    end

  end
end
