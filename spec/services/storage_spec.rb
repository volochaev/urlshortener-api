require 'spec_helper'

describe URLShortener::Storage do
  subject { APP.storage }

  context '.get' do
    it 'returns error when invalid/nonexisted key was passed' do
      expect do
        subject.get('bad key')
      end.to raise_error(URLShortener::AdapterEmptyResult)
    end
  end

  context '.save' do
    it 'validates input string' do
      expect { subject.save(nil) }.to raise_error(URLShortener::RequestError)
      expect { subject.save('') }.to raise_error(URLShortener::RequestError)
      expect { subject.save('foo') }.to raise_error(URLShortener::RequestError)
    end
  end
end
