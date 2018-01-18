require 'cache_sync/cache'

module CacheSync
  class Redis < Cache
    require 'redis'

    @redis = nil

    def initialize
      @redis = ::Redis.new
    end

    def read_version
      @redis.get("weeler-cache-sync").to_f
    end

    def write_version version
      @redis.set("weeler-cache-sync", version)
    end

    def cache_set_up
      @redis.ping
    rescue
      false
    end

  end
end
