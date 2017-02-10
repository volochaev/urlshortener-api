require 'spec_helper'
require 'shared_examples'

describe URLShortener::Application do
  let(:app) { Rack::MockRequest.new(APP) }

  request_to_string = ->(hash) { { input: hash.to_json } }

  context '/' do
    context 'GET' do
      let(:response) { app.get('/') }
      let(:headers) { response.headers }

      it 'return a 200 code' do
        expect(response.status).to eq(200)
      end

      it 'contain current application version' do
        body = JSON.parse(response.body)
        expect(body).to eq('version' => URLShortener::VERSION)
      end

      it 'be a JSON' do
        expect(headers).to include('Content-Type' => 'application/json')
      end
    end

    context 'POST' do
      context 'when valid data was passed' do
        let(:response) {
          app.post('/', request_to_string[{ url: 'http://example.com' }])
        }
        let(:headers) { response.headers }

        it 'return a 200 code' do
          expect(response.status).to eq(200)
        end

        it 'contain key' do
          body = JSON.parse(response.body)
          expect(body).to include('url')
        end

        it 'be a JSON' do
          expect(headers).to include('Content-Type' => 'application/json')
        end
      end

      context 'when invalid data was passed' do
        context 'in case of empty body' do
          it_behaves_like 'failed post request' do
            let(:response) { app.post('/', {}) }
          end
        end

        context 'in case of non-JSON string in body' do
          it_behaves_like 'failed post request' do
            let(:response) { app.post('/', input: 'regular string') }
          end
        end

        context 'in case of missing `url` key in JSON' do
          it_behaves_like 'failed post request' do
            let(:response) {
              app.post('/', request_to_string[{ test: 'test' }])
            }
          end
        end

        context 'in case of invalid uri' do
          it_behaves_like 'failed post request' do
            let(:response) {
              app.post('/', request_to_string[{ url: 'example.com/space here.html' }])
            }
          end
        end
      end
    end
  end
end
