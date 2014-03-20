require 'spec_helper'

describe 'the limit command' do
  it 'should parse limit 1' do
    result = Plunk.search 'limit 1'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.limit_builder(1)
    )
    expect(result).to eq(expected)
  end
end
