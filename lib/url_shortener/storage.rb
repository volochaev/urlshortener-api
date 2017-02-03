require 'url_shortener/adapters'

module URLShortener
  class Storage < Application # :nodoc:
    def initialize
      @adapter ||=
        case config.storage['adapter']
        when :redis, 'redis'
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
      if url.nil? || url.empty? || (url =~ URI.regexp).nil?
        raise RequestError, 'Request error: malformed request'
      end

      @adapter.save(url)
    end
  end
end
