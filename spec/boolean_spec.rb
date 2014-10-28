require 'spec_helper'

describe 'boolean searches' do

  it 'should parse (foo OR bar)' do
    result = Peruse.search '(foo OR bar)'
    expected = Peruse::Helper.filter_builder({
      or: [
        Peruse::Helper.query_builder('foo'),
        Peruse::Helper.query_builder('bar')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo | bar)' do
    result = Peruse.search '(foo | bar)'
    expected = Peruse::Helper.filter_builder({
      or: [
        Peruse::Helper.query_builder('foo'),
        Peruse::Helper.query_builder('bar')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo OR (bar AND baz))' do
    result = Peruse.search '(foo OR (bar AND baz))'
    expected = Peruse::Helper.filter_builder({
      or: [
        Peruse::Helper.query_builder('foo'),
        {
          and: [
            Peruse::Helper.query_builder('bar'),
            Peruse::Helper.query_builder('baz')
          ]
        }
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar & baz=fez & fad=bad' do
    result = Peruse.search 'foo=bar & baz=fez & fad=bad'
    expected = Peruse::Helper.filter_builder({
      and: [
        Peruse::Helper.query_builder('foo:bar'),
        Peruse::Helper.query_builder('baz:fez'),
        Peruse::Helper.query_builder('fad:bad')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar | foo=baz | fez=baz' do
    result = Peruse.search 'foo=bar | foo=baz | fez=baz'
    expected = Peruse::Helper.filter_builder({
      or: [
        Peruse::Helper.query_builder('foo:bar'),
        Peruse::Helper.query_builder('foo:baz'),
        Peruse::Helper.query_builder('fez:baz')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo=bar OR foo=bar)' do
    result = Peruse.search '(foo=bar OR foo=bar)'
    expected = Peruse::Helper.filter_builder({
      or: [
        Peruse::Helper.query_builder('foo:bar'),
        Peruse::Helper.query_builder('foo:bar')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar OR baz=fez' do
    result = Peruse.search 'foo=bar OR baz=fez'
    expected = Peruse::Helper.filter_builder({
      or: [
        Peruse::Helper.query_builder('foo:bar'),
        Peruse::Helper.query_builder('baz:fez')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse (foo=bar AND baz=fez) OR ham=cheese' do
    result = Peruse.search '(foo=bar AND baz=fez) OR ham=cheese'
    expected = Peruse::Helper.filter_builder({
      or: [
        {
          and: [
            Peruse::Helper.query_builder('foo:bar'),
            Peruse::Helper.query_builder('baz:fez')
          ]
        },
        Peruse::Helper.query_builder('ham:cheese')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse NOT foo=bar' do
    result = Peruse.search 'NOT foo=bar'
    expected = Peruse::Helper.filter_builder({
      not: Peruse::Helper.query_builder('foo:bar')
    })
    expect(result).to eq(expected)
  end
end
