require 'spec_helper'

describe 'boolean searches' do
  it 'should parse (foo OR bar)' do
    parsed = @parser.parse '(foo OR bar)'
    result = @transformer.apply parsed
    pp result
    expected = Plunk::Helper.filter_builder({
      or: [ Plunk::Helper.query_builder('foo'), Plunk::Helper.query_builder('bar') ] })
    expect(Plunk::ResultSet.new(result).query).to eq(expected)
  end

  it 'should parse (foo OR (bar AND baz))' do
    result = @transformer.apply @parser.parse '(foo OR (bar AND baz))'
    expected = filter_builder({
      or: [
        query_builder('foo'),
        {
          and: [
            query_builder('bar'),
            query_builder('baz')
          ]
        }
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse (foo=bar OR foo=bar)' do
    result = @transformer.apply @parser.parse '(foo=bar OR foo=bar)'
    expected = filter_builder({
      or: [
        query_builder('foo:bar'),
        query_builder('foo:bar')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse foo=bar OR baz=fez' do
    result = @transformer.apply @parser.parse 'foo=bar OR baz=fez'
    expected = filter_builder({
      or: [
        query_builder('foo:bar'),
        query_builder('baz:fez')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse (foo=bar AND baz=fez) OR ham=cheese' do
    result = @transformer.apply @parser.parse '(foo=bar AND baz=fez) OR ham=cheese'
    expected = filter_builder({
      or: [
        {
          and: [
            query_builder('foo:bar'),
            query_builder('baz:fez')
          ]
        },
        query_builder('ham:cheese')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse NOT foo=bar' do
    result = @transformer.apply @parser.parse 'NOT foo=bar'
    expected = filter_builder({
      not: query_builder('foo:bar')
    })
    expect(result.query).to eq(expected)
  end
end
