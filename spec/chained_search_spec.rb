require 'spec_helper'

describe 'chained searches' do
  it 'should parse last 24h foo=bar baz=fez' do
    result = @transformer.apply @parser.parse 'last 24h foo=bar baz=fez'
    puts result
    expect(result.query).to eq({query:{filtered:{query:{
      range: {
        '@timestamp' => {
          gte: 1.day.ago.utc.iso8601(3),
          lte: Time.now.utc.iso8601(3)
        }
      },
      filter: {
        and: [
          query_string: {
            query: 'foo:bar'
          },
          query_string: {
            query: 'baz:fez'
          }
    ]}}}}})
  end
end
