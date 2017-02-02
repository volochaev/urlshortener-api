module URLShortener
  class Storage < Application # :nodoc:
    def initialize
      @adapter ||=
        case config.storage['adapter']
        when :redis, 'redis'
          require 'url_shortener/adapters/redis_adapter.rb'
          Adapters::RedisAdapter.new(config.storage)
        else
          raise AdapterError, 'No storage adapter was specified'
        end
    end

    def get(id)
      result = @adapter.get(id)
      result ? result : raise(AdapterEmptyResult)
    end

    def save(url)
      @adapter.save(url)
    end
  end
end
