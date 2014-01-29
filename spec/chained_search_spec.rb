require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'

describe 'chained searches' do
  include_context "time stubs"
  include_context "plunk stubs"

  before :each do
    @time = Time.parse("01/01/2010 10:00")
    Time.any_instance.stub(:now).and_return(@time)
  end

  it 'should parse last 24h foo_type=bar baz="fez" host=27.224.123.110' do
    parsed = @parser.parse 'last 24h foo_type=bar baz="fez" host=27.224.123.110'
    result = @transformer.apply parsed
    expect(result.query).to eq({query:{filtered:{query:{
      query_string: {
        query: 'foo_type:bar'
      }},
      filter: {
        and: [{
          range: {
            :timestamp => {
              gte: @time - 24.hours,
              lte: @time
            }
          }},
          {query_string: {
            query: 'baz:fez'
          }},
          {query_string: {
            query: 'host:27.224.123.110'
          }}
    ]}}}})
  end

  pending 'should parse last 24h (foo_type=bar AND baz="fez" AND host=27.224.123.110)' do
    parsed = @parser.parse 'last 24h (foo_type=bar AND baz="fez" AND host=27.224.123.110)'
    result = @transformer.apply parsed
    expect(result.query).to eq({query:{filtered:{query:{
      query_string: {
        query: 'foo_type:bar'
      }},
      filter: {
        and: [{
          range: {
            :timestamp => {
              gte: 1.day.ago.utc.iso8601(3),
              lte: @time
            }
          }},
          {query_string: {
            query: 'baz:fez'
          }},
          {query_string: {
            query: 'host:27.224.123.110'
          }}
    ]}}}})
  end
end
