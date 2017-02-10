require 'spec_helper'

describe URLShortener::Application do
  subject { APP }

  it 'returns config' do
    expect(subject.config).to \
      be_an_instance_of(URLShortener::Application::Configuration)
  end

  it 'returns version as Rack response-ready Array' do
    expect(subject.version).to eq [
      200, { 'Content-Type' => 'application/json' },
      [{ version: URLShortener::VERSION }.to_json]
    ]
  end

  it 'handles internal exceptions' do
    ex = URLShortener::RequestError.new('test')

    expect(subject.send(:handle_exception, ex)).to eq [
      400, { 'Content-Type' => 'application/json' },
      [{ error: 'test' }.to_json]
    ]
  end
end
