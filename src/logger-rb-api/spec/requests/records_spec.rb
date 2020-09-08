require 'rails_helper'

RSpec.describe 'Records API', type: :request do
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

  describe 'POST /records with correct payload' do
    subject do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/records', params: '{ "creator": "creator", "logs": [ {"category": "category", "key": "key", "value": "value" } ] }', headers: headers
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'logger' })
        end

        context 'with new creator/category' do
          it 'returns status code 204 and creates creator and category' do
            numCreators = Creator.all.count
            numCategories = Creator.all.count
            numRecords = Record.all.count
            expect(subject).to eq(204)

            expect(Creator.all.count).to eq(numCreators + 1)
            expect(Creator.all.count).to eq(numCategories + 1)
            expect(Record.all.count).to eq(numRecords + 1)
          end
        end

        context 'with existing creator/category' do
          it 'returns status code 204 and creates creator and category' do
            creator = Creator.find_or_create_by(name: 'creator')
            category = Category.find_or_create_by(name: 'category')

            numCreators = Creator.all.count
            numCategories = Creator.all.count
            numRecords = Record.all.count
            expect(subject).to eq(204)

            expect(Creator.all.count).to eq(numCreators)
            expect(Creator.all.count).to eq(numCategories)
            expect(Record.all.count).to eq(numRecords + 1)
          end
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'POST /records with missing payload' do
    subject do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/records', headers: headers
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'logger' })
        end

        it 'returns status code 422' do
          expect(subject).to eq(422)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'POST /records with partial payload' do
    subject do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/records', params: '{ "creator": "creator", "logs": [ {"key": "key", "value": "value" } ] }', headers: headers
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'logger' })
        end

        it 'returns status code 422' do
          expect(subject).to eq(422)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'POST /records with single log payload' do
    subject do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/records', params: '{ "creator": "creator", "category": "category", "key": "key", "value": "value" }', headers: headers
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'logger' })
        end

        it 'returns status code 422' do
          expect(subject).to eq(422)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end
end
