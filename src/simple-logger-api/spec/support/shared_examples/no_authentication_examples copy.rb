RSpec.shared_examples 'has no authentication' do
  context 'is not authenticated' do
    it 'returns status code 401' do
      expect(subject).to eq(401)
    end
  end
end
