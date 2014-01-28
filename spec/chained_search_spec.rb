require 'spec_helper'

describe 'chained searches' do
  it 'should parse last 24h foo=bar baz=fez' do
    parsed = @parser.parse 'last 24h foo=bar baz=fez ham=delicious'
    result = @transformer.apply parsed
    puts "PARSED: #{parsed}"
    puts "RESULT_SET: #{result.inspect}"
    expect(result.query).to eq({query:{filtered:{query:{
      query_string: {
        query: 'foo:bar'
      }},
      filter: {
        and: [{
          range: {
            :timestamp => {
              gte: 1.day.ago.utc.iso8601(3),
              lte: Time.now.utc.iso8601(3)
            }
          }},
          {query_string: {
            query: 'baz:fez'
          }},
          {query_string: {
            query: 'ham:delicious'
          }}
    ]}}}})
  end
end
