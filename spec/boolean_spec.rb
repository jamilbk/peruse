require 'spec_helper'

describe 'boolean searches' do

  it 'should parse (foo OR bar)' do
    result = Plunk.search '(foo OR bar)'
    expected = Plunk::Helper.filter_builder({
      or: [
        Plunk::Helper.query_builder('foo'),
        Plunk::Helper.query_builder('bar')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo | bar)' do
    result = Plunk.search '(foo | bar)'
    expected = Plunk::Helper.filter_builder({
      or: [
        Plunk::Helper.query_builder('foo'),
        Plunk::Helper.query_builder('bar')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo OR (bar AND baz))' do
    result = Plunk.search '(foo OR (bar AND baz))'
    expected = Plunk::Helper.filter_builder({
      or: [
        Plunk::Helper.query_builder('foo'),
        {
          and: [
            Plunk::Helper.query_builder('bar'),
            Plunk::Helper.query_builder('baz')
          ]
        }
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar & baz=fez & fad=bad' do
    result = Plunk.search 'foo=bar & baz=fez & fad=bad'
    expected = Plunk::Helper.filter_builder({
      and: [
        Plunk::Helper.query_builder('foo:bar'),
        Plunk::Helper.query_builder('baz:fez'),
        Plunk::Helper.query_builder('fad:bad')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar | foo=baz | fez=baz' do
    result = Plunk.search 'foo=bar | foo=baz | fez=baz'
    expected = Plunk::Helper.filter_builder({
      or: [
        Plunk::Helper.query_builder('foo:bar'),
        Plunk::Helper.query_builder('foo:baz'),
        Plunk::Helper.query_builder('fez:baz')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo=bar OR foo=bar)' do
    result = Plunk.search '(foo=bar OR foo=bar)'
    expected = Plunk::Helper.filter_builder({
      or: [
        Plunk::Helper.query_builder('foo:bar'),
        Plunk::Helper.query_builder('foo:bar')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar OR baz=fez' do
    result = Plunk.search 'foo=bar OR baz=fez'
    expected = Plunk::Helper.filter_builder({
      or: [
        Plunk::Helper.query_builder('foo:bar'),
        Plunk::Helper.query_builder('baz:fez')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo=bar AND baz=fez) OR ham=cheese' do
    result = Plunk.search '(foo=bar AND baz=fez) OR ham=cheese'
    expected = Plunk::Helper.filter_builder({
      or: [
        {
          and: [
            Plunk::Helper.query_builder('foo:bar'),
            Plunk::Helper.query_builder('baz:fez')
          ]
        },
        Plunk::Helper.query_builder('ham:cheese')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse NOT foo=bar' do
    result = Plunk.search 'NOT foo=bar'
    expected = Plunk::Helper.filter_builder({
      not: Plunk::Helper.query_builder('foo:bar')
    })
    expect(result).to eq(expected)
  end
end
