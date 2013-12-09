require 'spec_helper'

describe 'basic searches' do
  it 'should parse' do
    result = @transformer.apply @parser.parse('bar')
    result.query.should eq({
      query: {
        query_string: {
          query: 'bar'
    }}})
  end
end
