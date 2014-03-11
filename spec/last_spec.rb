require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'
require 'shared/query_builder'

describe 'the last command' do
  include_context "time stubs"
  include_context "plunk stubs"
  include QueryBuilder

  it 'should parse last 24h' do
    result = @transformer.apply @parser.parse('last 24h')
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.hours).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        )
      ]
    })
    expect(result.query.to_s).to eq(expected)
  end

  it 'should parse last 24d' do
    result = @transformer.apply @parser.parse('last 24d')
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.days).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        )
      ]
    })
    expect(result.query.to_s).to eq(expected)
  end

  it 'should parse last 24w' do
    result = @transformer.apply @parser.parse('last 24w')
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.weeks).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        )
      ]
    })
    expect(result.query.to_s).to eq(expected)
  end

  it 'should parse last 24s' do
    result = @transformer.apply @parser.parse('last 24s')
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.seconds).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        )
      ]
    })
    expect(result.query.to_s).to eq(expected)
  end

  it 'should parse last 24m' do
    result = @transformer.apply @parser.parse('last 24m')
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 24.minutes).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        )
      ]
    })
    expect(result.query.to_s).to eq(expected)
  end

  it 'should parse last 1h @fields.foo.@field=bar' do
    result = @transformer.apply @parser.parse('last 1h @fields.foo.@field=bar')
    expected = filter_builder({
      and: [
        range_builder(
          (@time - 1.hour).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        query_builder('@fields.foo.@field:bar')
      ]
    })
    expect(result.query.to_s).to eq(expected)
  end
end
