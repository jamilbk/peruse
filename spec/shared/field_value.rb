shared_examples 'field / value' do
  describe 'basic' do
    expect(query[:field].to_s).to eq expected[:field]
    expect(query[:value].to_s).to eq expected[:value]
    expect(query[:op].to_s).to eq expected[:op]
  end
end
