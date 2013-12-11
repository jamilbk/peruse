require 'spec_helper'

describe 'field / value searches' do
  it 'should parse a _foo.@bar=baz' do
    result = @transformer.apply @parser.parse('_foo.@bar=baz')
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '_foo.@bar:baz'
    }}}}})
  end

  it 'should parse a _foo.@bar=(baz)' do
    result = @transformer.apply @parser.parse('_foo.@bar=(baz)')
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '_foo.@bar:(baz)'
    }}}}})
  end

  it 'should parse _foo.@fields.@bar="bar baz"' do
    result = @transformer.apply @parser.parse '_foo.@fields.@bar="bar baz"'
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '_foo.@fields.@bar:"bar baz"'
    }}}}})
  end

  it 'should parse _foo-barcr@5Y_+f!3*(name=bar' do
    result = @transformer.apply @parser.parse '_foo-barcr@5Y_+f!3*(name=bar'
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '_foo-barcr@5Y_+f!3*(name:bar'
    }}}}})

  end
end
