module URLShortener
  # A base class which all other more specific errors derive
  class URLShortenerError < StandardError
    attr_reader :message
    attr_reader :response_code

    def initialize(message = nil, response_code = 500)
      @message       = message
      @response_code = response_code
    end
  end

  # Raised in cases where application can't retrieve data from storage
  # or other exception related to data storage occurred.
  class AdapterError < URLShortenerError
  end

  # Raised when an empty result returned from storage
  class AdapterEmptyResult < URLShortenerError
    def initialize
      super('Not found', 404)
    end
  end

  # Raised when a request is initiated with invalid parameters
  class RequestError < URLShortenerError
    def initialize(message)
      super(message, 400)
    end
  end

  # Raised in cases where a client is performing too many requests
  class RateLimitError < URLShortenerError
    def initialize(_retry_after)
      super(nil, 429)
    end
  end
end
