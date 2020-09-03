require 'rails_helper'

RSpec.describe 'Records API' do
  let!(:creator) { create(:creator) }
  let!(:category) { create(:category) }
  let!(:records) { create_list(:record, 20, creator_id: creator.id, category_id: category.id) }
  let(:creator_id) { creator.id }
  let(:id) { records.first.id }

  describe 'GET /creators/:creator_id/records' do
    subject do
      get "/creators/#{creator_id}/records"
    end

    context 'is authenticated' do
      context 'has correct scope' do
        before do
          allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'reader' })
        end

        context 'when creator exists' do
          it 'returns status code 200 and returns all records' do
            expect(subject).to eq(200)
          end
        end

        context 'when creator does not exist' do
          let(:creator_id) { 0 }

          it 'returns status code 404' do
            expect(subject).to eq(404)
          end
        end
      end

      include_examples 'has incorrect authentication'
    end

    include_examples 'has no authentication'
  end
end
