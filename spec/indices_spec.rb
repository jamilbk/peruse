require 'spec_helper'

describe 'the indices command' do
  it 'should parse indices foo,bar,baz' do
    result = Plunk.search 'indices foo,bar,baz'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.indices_builder(%w(foo bar baz))
    )
    expect(result).to eq(expected)
  end

  it 'should parse indices foo , bar , baz' do
    result = Plunk.search 'indices foo , bar , baz'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.indices_builder(%w(foo bar baz))
    )
    expect(result).to eq(expected)
  end

  it 'should parse indices foo , bar , baz & key = value' do
    result = Plunk.search 'indices foo , bar , baz & key = value'
    expected = Plunk::Helper.filter_builder(
      and: [
        Plunk::Helper.indices_builder(%w(foo bar baz)),
        Plunk::Helper.query_builder('key:value')
      ]
    )
    expect(result).to eq(expected)
  end

  it 'should parse key = value & indices foo , bar , baz' do
    result = Plunk.search 'key = value & indices foo , bar , baz'
    expected = Plunk::Helper.filter_builder(
      and: [
        Plunk::Helper.query_builder('key:value'),
        Plunk::Helper.indices_builder(%w(foo bar baz))
      ]
    )
    expect(result).to eq(expected)
  end
end
