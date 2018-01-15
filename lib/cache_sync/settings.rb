require 'cache_sync/cache'

module CacheSync
  class Settings < Cache

    def read_version
      ::Settings.i18n_updated_at
    end

    def write_version version
      ::Settings.i18n_updated_at = version
    end

  end
end
