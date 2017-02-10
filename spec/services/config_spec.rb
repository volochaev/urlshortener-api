require 'spec_helper'

describe URLShortener::Application::Configuration do
  context '.initialize' do
    it 'load `config.yml` with corresponding `RACK_ENV`' do
      expect { described_class.new }.not_to raise_error
    end

    it 'symbolize keys' do
      condition = described_class.new.config.keys.all? { |k| k.is_a? Symbol }
      expect(condition).to be true
    end
  end

  context '.method_missing' do
    let(:config) { described_class.new }

    it 'uses `method_missing` for hash access' do
      expect(config.storage).to be_an_instance_of(Hash)
    end

    it 'returns exception when no such key in config present' do
      expect { config.foobar }.to raise_error(NoMethodError)
    end
  end

  context '.respond_to_missing?' do
    let(:config) { described_class.new }

    it 'returns true if key exists' do
      expect(config).to respond_to(:storage)
    end

    it 'returns false if no such key present' do
      expect(config).not_to respond_to(:foobar)
    end
  end
end
