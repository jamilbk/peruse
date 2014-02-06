require 'spec_helper'

describe 'regexp searches' do
  it 'should parse foo=/blah foo/' do
    result = @transformer.apply @parser.parse('foo=/blah foo/')
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: 'foo:/blah foo/'
    }}}}})
  end

  it 'should parse foo=/blah\/ foo/' do
    result = @transformer.apply @parser.parse('foo=/blah\/ foo/')
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: 'foo:/blah\/ foo/'
    }}}}})
  end
end
