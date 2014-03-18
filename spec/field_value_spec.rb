require 'spec_helper'

describe 'field / value searches' do

  it 'should parse _foo.@bar=baz' do
    result = Plunk.search '_foo.@bar=baz'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('_foo.@bar:baz')
    )
    expect(result).to eq(expected)
  end

  it 'should parse _foo.@bar=(baz)' do
    result = Plunk.search '_foo.@bar=(baz)'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('_foo.@bar:(baz)')
    )
    expect(result).to eq(expected)
  end

  it 'should parse _foo.@fields.@bar="bar baz"' do
    result = Plunk.search '_foo.@fields.@bar="bar baz"'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('_foo.@fields.@bar:"bar baz"')
    )
    expect(result).to eq(expected)
  end

  it 'should parse _foo-barcr@5Y_+f!3*(name=bar' do
    result = Plunk.search '_foo-barcr@5Y_+f!3*(name=bar'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('_foo-barcr@5Y_+f!3*(name:bar')
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar-baz' do
    result = Plunk.search 'foo=bar-baz'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.query_builder('foo:bar-baz')
    )
    expect(result).to eq(expected)
  end
end
