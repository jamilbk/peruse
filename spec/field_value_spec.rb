require 'spec_helper'

describe 'field / value searches' do

  it 'should parse _foo.@bar=baz' do
    result = Peruse.search '_foo.@bar=baz'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.query_builder('_foo.@bar:baz')
    )
    expect(result).to eq(expected)
  end

  it 'should parse _foo.@bar=(baz)' do
    result = Peruse.search '_foo.@bar=(baz)'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.query_builder('_foo.@bar:(baz)')
    )
    expect(result).to eq(expected)
  end

  it 'should parse _foo.@fields.@bar="bar baz"' do
    result = Peruse.search '_foo.@fields.@bar="bar baz"'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.query_builder('_foo.@fields.@bar:"bar baz"')
    )
    expect(result).to eq(expected)
  end

  it 'should parse _foo-barcr@5Y_+f!3*(name=bar' do
    result = Peruse.search '_foo-barcr@5Y_+f!3*(name=bar'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.query_builder('_foo-barcr@5Y_+f!3*(name:bar')
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=bar-baz' do
    result = Peruse.search 'foo=bar-baz'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.query_builder('foo:bar-baz')
    )
    expect(result).to eq(expected)
  end

  it 'should parse !src_ip=0.0.0.0' do
    result = Peruse.search '!src_ip=0.0.0.0'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.query_builder('!src_ip:0.0.0.0')
    )
    expect(result).to eq(expected)
  end
end
