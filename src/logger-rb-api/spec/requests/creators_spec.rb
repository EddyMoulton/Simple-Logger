require 'rails_helper'

RSpec.describe 'Creators API', type: :request do
  let!(:creators) { create_list(:creator, 10) }
  let(:creator_id) { creators.first.id }

  describe 'GET /creators' do
    subject do
      get '/creators'
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        it 'returns status code 200 and creators' do
          expect(subject).to eq(200)
          expect(json).not_to be_empty
          expect(json.size).to eq(10)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'GET /creators/:id' do
    subject do
      get "/creators/#{creator_id}"
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before(:each) do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        context 'when the record exists' do
          it 'returns status code 200 and the creator' do
            expect(subject).to eq(200)
            expect(json).not_to be_empty
            expect(json['id']).to eq(creator_id)
          end
        end

        context 'when the record does not exist' do
          let(:creator_id) { 100 }

          it 'returns status code 404 and a not found messages' do
            expect(subject).to eq(404)
            expect(json['message']).to match(/Couldn't find Creator/)
          end
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'DELETE /creators/:id' do
    subject do
      delete "/creators/#{creator_id}"
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before(:each) do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'deleter' })
        end

        it 'returns status code 204' do
          expect(subject).to eq(204)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end
end
