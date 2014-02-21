require 'spec_helper'

describe 'basic searches' do
  it 'should parse bar' do
    result = @transformer.apply @parser.parse('bar')
    result.query.should eq({query:{filtered:{query:{query_string:{
      query: 'bar'
    }}}}})
  end

  it 'should parse  bar ' do
    result = @transformer.apply @parser.parse(' bar ')
    result.query.should eq({query:{filtered:{query:{query_string:{
      query: 'bar'
    }}}}})
  end
end
