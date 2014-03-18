require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'

describe 'the last command' do
  include_context "time stubs"
  include_context "plunk stubs"

  it 'should parse last 24h' do
    result = Plunk.search 'last 24h'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        (@time - 24.hours).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24d' do
    result = Plunk.search 'last 24d'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        (@time - 24.days).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24w' do
    result = Plunk.search 'last 24w'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        (@time - 24.weeks).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24s' do
    result = Plunk.search 'last 24s'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        (@time - 24.seconds).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24m' do
    result = Plunk.search 'last 24m'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        (@time - 24.minutes).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 1h & @fields.foo.@field=bar' do
    result = Plunk.search 'last 1h & @fields.foo.@field=bar'
    expected = Plunk::Helper.filter_builder(
      and: [
        Plunk::Helper.range_builder(
          (@time - 1.hour).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        Plunk::Helper.query_builder('@fields.foo.@field:bar')
      ]
    )
    expect(result).to eq(expected)
  end
end
