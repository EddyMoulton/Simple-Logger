require 'rails_helper'

RSpec.describe 'Records API' do
  let!(:creator) { create(:creator) }
  let!(:category) { create(:category) }
  let!(:records) { create_list(:record, 20, creator_id: creator.id, category_id: category.id) }
  let(:id) { records.first.id }

  describe 'GET /records' do
    subject do
      get '/records'
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        it 'returns status code 200 and all records' do
          expect(subject).to eq(200)
          expect(json.size).to eq(20)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'GET /records/:id' do
    subject do
      get "/records/#{id}"
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        it 'returns status code 200 and all records' do
          expect(subject).to eq(200)
          expect(json['id']).to eq(id)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end
end
