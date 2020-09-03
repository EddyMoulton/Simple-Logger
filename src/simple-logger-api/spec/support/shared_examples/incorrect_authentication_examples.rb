RSpec.shared_examples 'has incorrect authentication' do
  context 'has no scope' do
    before(:each) do
      allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => '' })
    end

    it 'returns status code 401' do
      expect(subject).to eq(401)
    end
  end

  context 'has incorrect scope' do
    before(:each) do
      allow(JsonWebToken).to receive(:verify).and_return({ 'scope' => 'incorrect scope' })
    end

    it 'returns status code 401' do
      expect(subject).to eq(401)
    end
  end
end
