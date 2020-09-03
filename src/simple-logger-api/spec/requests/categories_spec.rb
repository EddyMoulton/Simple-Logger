require 'rails_helper'

RSpec.describe 'Categories API', type: :request do
  let!(:categories) { create_list(:category, 10) }
  let(:category_id) { categories.first.id }

  describe 'GET /categories' do
    subject do
      get '/categories'
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        it 'returns status code 200 and categories' do
          expect(subject).to eq(200)
          expect(json).not_to be_empty
          expect(json.size).to eq(10)
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'GET /categories/:id' do
    subject do
      get "/categories/#{category_id}"
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before(:each) do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        context 'when the record exists' do
          it 'returns status code 200 and the category' do
            expect(subject).to eq(200)
            expect(json).not_to be_empty
            expect(json['id']).to eq(category_id)
          end
        end

        context 'when the record does not exist' do
          let(:category_id) { 100 }

          it 'returns status code 404 and a not found messages' do
            expect(subject).to eq(404)
            expect(json['message']).to match(/Couldn't find Category/)
          end
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end

  describe 'DELETE /categories/:id' do
    subject do
      delete "/categories/#{category_id}"
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
