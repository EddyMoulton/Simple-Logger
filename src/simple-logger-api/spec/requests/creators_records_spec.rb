require 'rails_helper'

RSpec.describe 'Records API' do
  let!(:creator) { create(:creator) }
  let!(:category) { create(:category) }
  let!(:records) { create_list(:record, 20, creator_id: creator.id, category_id: category.id) }
  let(:creator_id) { creator.id }
  let(:id) { records.first.id }

  describe 'GET /creators/:creator_id/records' do
    before { get "/creators/#{creator_id}/records" }

    context 'when creator exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all records' do
        expect(json.size).to eq(20)
      end
    end

    context 'when creator does not exist' do
      let(:creator_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Creator/)
      end
    end
  end

end