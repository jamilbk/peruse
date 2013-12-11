require 'spec_helper'

describe 'boolean searches' do
  it 'should parse (foo OR bar)' do
    result = @transformer.apply @parser.parse '(foo OR bar)'
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '(foo OR bar)'
    }}}}})
  end

  it 'should parse (foo OR (bar AND baz))' do
    result = @transformer.apply @parser.parse '(foo OR (bar AND baz))'
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '(foo OR (bar AND baz))'
    }}}}})
  end
end
