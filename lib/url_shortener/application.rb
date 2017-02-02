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

    def process_get_request(env); end

    def post_requests_handler(env); end

    def version_as_json
      { version: VERSION }.to_json
    end

    private

    def handle_exception(e)
      response_code = e.respond_to?(:response_code) ? e.response_code : 500
      [response_code, { 'Content-Type' => 'text/html' }, [e.message]]
    end
  end
end
