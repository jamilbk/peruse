require 'spec_helper'

describe 'regexp searches' do

  it 'should parse foo=/blah foo/' do
    result = Plunk.search 'foo=/blah foo/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('foo:/blah foo/')
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=/blah\/ foo/' do
    result = Plunk.search 'foo=/blah\/ foo/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('foo:/blah\/ foo/')
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=/blah\. foo/' do
    result = Plunk.search 'foo=/blah\. foo/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('foo:/blah\. foo/')
    )
    expect(result).to eq(expected)
  end
end
