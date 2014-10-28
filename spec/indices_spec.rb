require 'spec_helper'

describe 'the indices command' do
  it 'should parse indices foo,bar,baz' do
    result = Peruse.search 'indices foo,bar,baz'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.indices_builder(%w(foo bar baz))
    )
    expect(result).to eq(expected)
  end

  it 'should parse indices foo , bar , baz' do
    result = Peruse.search 'indices foo , bar , baz'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.indices_builder(%w(foo bar baz))
    )
    expect(result).to eq(expected)
  end

  it 'should parse indices foo , bar , baz & key = value' do
    result = Peruse.search 'indices foo , bar , baz & key = value'
    expected = Peruse::Helper.filter_builder(
      and: [
        Peruse::Helper.indices_builder(%w(foo bar baz)),
        Peruse::Helper.query_builder('key:value')
      ]
    )
    expect(result).to eq(expected)
  end

  it 'should parse key = value & indices foo , bar , baz' do
    result = Peruse.search 'key = value & indices foo , bar , baz'
    expected = Peruse::Helper.filter_builder(
      and: [
        Peruse::Helper.query_builder('key:value'),
        Peruse::Helper.indices_builder(%w(foo bar baz))
      ]
    )
    expect(result).to eq(expected)
  end
end
