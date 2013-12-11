require 'spec_helper'

describe 'field / value searches' do
  it 'should parse a single _foo.@bar=baz' do
    result = @transformer.apply @parser.parse('_foo.@bar=baz')
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '_foo.@bar:baz'
    }}}}})
  end

  it 'should parse a single _foo.@bar=(baz)' do
    result = @transformer.apply @parser.parse('_foo.@bar=(baz)')
    expect(result.query).to eq({query:{filtered:{query:{query_string:{
      query: '_foo.@bar:(baz)'
    }}}}})
  end
end
