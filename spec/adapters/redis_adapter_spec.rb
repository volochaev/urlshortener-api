require 'spec_helper'

if current_adapter?(:redis)
  describe URLShortener::Adapters::RedisAdapter do
    subject { APP.storage.adapter }

    context 'Redis adapter' do
      it 'establish connection to Redis' do
        expect(subject.ping).to eq('PONG')
      end

      context '.save/.get' do
        let(:saved) { subject.save('test') }

        it 'save passed string' do
          expect { saved }.not_to raise_error
        end

        it 'returns original value' do
          expect(subject.get(saved)).to eq('test')
        end
      end
    end
  end
end
