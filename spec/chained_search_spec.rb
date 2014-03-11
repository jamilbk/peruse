require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'
require 'shared/query_builder'

describe 'chained searches' do
  include_context "time stubs"
  include_context "plunk stubs"
  include QueryBuilder

  it 'should parse last 24h foo_type=bar baz="fez" host=27.224.123.110' do
    parsed = @parser.parse 'last 24h foo_type=bar baz="fez" host=27.224.123.110'
    result = @transformer.apply parsed
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.hours).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        query_builder('foo_type:bar'),
        query_builder('baz:"fez"'),
        query_builder('host:27.224.123.110')
      ]
    })
    expect(result.query).to eq(expected)
  end

  pending 'should parse last 24h (foo_type=bar AND baz="fez" AND host=27.224.123.110)' do
    parsed = @parser.parse 'last 24h (foo_type=bar AND baz="fez" AND host=27.224.123.110)'
    result = @transformer.apply parsed
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.hours).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        query_builder('foo_type:bar'),
        query_builder('baz:"fez"'),
        query_builder('host:27.224.123.110')
      ]
    })
    expect(result.query).to eq(expected)
  end
end
