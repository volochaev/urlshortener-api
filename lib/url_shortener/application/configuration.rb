require 'yaml'

module URLShortener
  class Application
    class Configuration # :nodoc:
      attr_reader :config

      def initialize
        @config ||= \
          YAML.load_file('./config/config.yml')[ENV['RACK_ENV']].tap do |hash|
            hash.clone.each_key { |k| hash[k.to_sym] = hash.delete(k) }
          end
      end

      def method_missing(method_name)
        if config.key? method_name
          config[method_name]
        else
          super
        end
      end

      def respond_to_missing?(method_name, _)
        config.key?(method_name)
      end
    end
  end
end
