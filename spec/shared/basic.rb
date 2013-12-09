shared_examples 'basic' do
  describe 'string' do
    expect(query[:match].to_s).to eq expected[:match]
  end
end
