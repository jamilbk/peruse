shared_examples 'last' do
  describe 'basic' do
    expect(query[:timerange][:quantity].to_s).to eq expected[:quantity]
    expect(query[:timerange][:quantifier].to_s).to eq expected[:quantifier]
  end
end
