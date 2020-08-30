require 'rails_helper'

RSpec.describe 'Records API' do
  let!(:creator) { create(:creator) }
  let!(:category) { create(:category) }
  let!(:records) { create_list(:record, 20, creator_id: creator.id, category_id: category.id) }
  let(:creator_id) { creator.id }
  let(:category_id) { category.id }
  let(:id) { records.first.id }

  describe 'GET /records' do
    before { get '/records' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all records' do
      expect(json.size).to eq(20)
    end
  end

  describe 'GET /records/:id' do
    before { get "/records/#{id}" }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the record' do
      expect(json['id']).to eq(id)
    end
  end
end