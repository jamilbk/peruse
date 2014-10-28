require 'spec_helper'

describe 'the limit command' do
  it 'should parse limit 1' do
    result = Peruse.search 'limit 1'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.limit_builder(1)
    )
    expect(result).to eq(expected)
  end
end
