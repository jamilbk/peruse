require 'spec_helper'
require 'shared/query_builder'

describe 'regexp searches' do
  include QueryBuilder

  it 'should parse foo=/blah foo/' do
    result = @transformer.apply @parser.parse('foo=/blah foo/')
    expected = filter_builder({
      and: [
        query_builder('foo:/blah foo/')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse foo=/blah\/ foo/' do
    result = @transformer.apply @parser.parse('foo=/blah\/ foo/')
    expected = filter_builder({
      and: [
        query_builder('foo:/blah\/ foo/')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse foo=/blah\. foo/' do
    result = @transformer.apply @parser.parse('foo=/blah\. foo/')
    expected = filter_builder({
      and: [
        query_builder('foo:/blah\. foo/')
      ]
    })
    expect(result.query).to eq(expected)
  end
end
