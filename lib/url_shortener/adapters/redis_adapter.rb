begin
  require 'connection_pool'
  require 'hashids'
  require 'redis'
rescue LoadError => e
  raise LoadError, <<-MSG
    Failed to load library.
    Maybe you need to add missing dependency to Gemfile.
    Error message: #{e.message}
  MSG
end

module URLShortener
  module Adapters
    class RedisAdapter # :nodoc:
      def initialize(options = {})
        pool  = options.fetch('pool', 5)
        salt  = options.fetch('salt')
        @key  = options.fetch('namespace')
        @counter_key = [@key, 'counter'].join(':')

        @pool = ConnectionPool.new(size: pool, timeout: 5) do
          Redis.new(options)
        end

        @hashids = Hashids.new(salt)
      end

      def get(id)
        decoded_id = @hashids.decode(id)

        @pool.with { |conn| conn.get [@key, decoded_id[0]].join(':') }
      end

      def save(url)
        result = @pool.with do |conn|
          conn.watch(@counter_key) do
            new_id = (conn.get(@counter_key) || 0).to_i + 1
            conn.multi do |multi|
              multi.set([@key, new_id].join(':'), url)
              multi.incr(@counter_key)
            end
          end
        end

        @hashids.encode result.last
      end

      def ping
        @pool.with(&:ping)
      end
    end
  end
end
