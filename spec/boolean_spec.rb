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

  it 'should parse (foo=bar OR foo=bar)' do
    parsed = @parser.parse '(foo=bar OR foo=bar)'
    puts parsed
    result = @transformer.apply parsed
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '(foo:bar OR foo:bar)'
    }}}}})
  end

  it 'should parse foo=bar OR baz=fez' do
    parsed = @parser.parse 'foo=bar OR baz=fez'
    puts parsed
    result = @transformer.apply parsed
    expect(result.query).to eq({query:{filtered:{query:{
      query_string:{
        query: 'foo:bar OR baz:fez'
      }},
    }}})
  end

  it 'should parse (foo=bar AND baz=fez) OR ham=cheese' do
    parsed = @parser.parse '(foo=bar AND baz=fez) OR ham=cheese'
    puts parsed
    result = @transformer.apply parsed
    expect(result.query).to eq({query:{filtered:{query:{
      query_string:{
        query: '(foo:bar AND baz:fez) OR ham:cheese'
      }},
    }}})
  end
end
