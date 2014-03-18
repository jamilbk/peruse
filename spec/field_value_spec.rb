require 'spec_helper'

describe 'field / value searches' do

  it 'should parse _foo.@bar=baz' do
    result = @transformer.apply @parser.parse('_foo.@bar=baz')
    expected = filter_builder({
      and: [
        query_builder('_foo.@bar:baz')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse _foo.@bar=(baz)' do
    result = @transformer.apply @parser.parse('_foo.@bar=(baz)')
    expected = filter_builder({
      and: [
        query_builder('_foo.@bar:(baz)')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse _foo.@fields.@bar="bar baz"' do
    result = @transformer.apply @parser.parse '_foo.@fields.@bar="bar baz"'
    expected = filter_builder({
      and: [
        query_builder('_foo.@fields.@bar:"bar baz"')
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse _foo-barcr@5Y_+f!3*(name=bar' do
    result = @transformer.apply @parser.parse '_foo-barcr@5Y_+f!3*(name=bar'
    expected = filter_builder({
      and: [
        query_builder: '_foo-barcr@5Y_+f!3*(name:bar'
      ]
    })
    expect(result.query).to eq(expected)
  end

  it 'should parse foo=bar-baz' do
    result = @transformer.apply @parser.parse 'foo=bar-baz'
    expected = filter_builder({
      and: [
        query_builder('foo:bar-baz')
      ]
    })
    expect(result.query).to eq(expected)
  end
end
