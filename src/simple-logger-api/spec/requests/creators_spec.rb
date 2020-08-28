require 'rails_helper'

RSpec.describe 'Creators API', type: :request do
  let!(:creators) { create_list(:creator, 10) }
  let(:creator_id) { creators.first.id }

  describe 'GET /creators' do
    before { get '/creators' }

    it 'returns creators' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /creators/:id' do
    before { get "/creators/#{creator_id}" }

    context 'when the record exists' do
      it 'returns the creator' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(creator_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:creator_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Creator/)
      end
    end
  end

  describe 'DELETE /creators/:id' do
    before { delete "/creators/#{creator_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end