module URLShortener
  class Application # :nodoc:
    attr_reader :storage

    def initialize
      @storage = Storage.new
    end

    def config
      @config ||= Application::Configuration.new
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'GET'  then process_get_request(env)
      when 'POST' then process_post_request(env)
      else
        raise RequestError, 'Request error: Unsupported method'
      end
    rescue URLShortenerError => e
      handle_exception(e)
    end

    def process_get_request(env)
      case path = env['PATH_INFO']
      when '/' then version
      when %r{\A\/\w+}
        headers = {
          'Location' => storage.get(path.sub!('/', '')),
          'Content-Type' => 'text/html', 'Content-Length' => '0'
        }
        [301, headers, []]
      else [404, { 'Content-Type' => 'application/json' }, ['']]
      end
    end

    def process_post_request(env)
      input = JSON.parse(env['rack.input'].read, symbolize_names: true)
      result = storage.save(input[:url])

      [
        200, { 'Content-Type' => 'application/json' },
        [{ url: [env['HTTP_HOST'], result].join('/') }.to_json]
      ]
    rescue JSON::ParserError
      raise RequestError, 'Request error: malformed request'
    end

    def version
      [
        200, { 'Content-Type' => 'application/json' },
        [{ version: VERSION }.to_json]
      ]
    end

    private

    def handle_exception(e)
      response_code = e.respond_to?(:response_code) ? e.response_code : 500

      [
        response_code, { 'Content-Type' => 'application/json' },
        [{ error: e.message }.to_json]
      ]
    end
  end
end
