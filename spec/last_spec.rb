require 'spec_helper'
require 'shared/time_stubs'
require 'shared/peruse_stubs'

describe 'the last command' do
  include_context "time stubs"
  include_context "peruse stubs"

  it 'should parse last 24h' do
    result = Peruse.search 'last 24h'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        (@time - 24.hours).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24d' do
    result = Peruse.search 'last 24d'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        (@time - 24.days).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24w' do
    result = Peruse.search 'last 24w'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        (@time - 24.weeks).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24s' do
    result = Peruse.search 'last 24s'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        (@time - 24.seconds).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 24m' do
    result = Peruse.search 'last 24m'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        (@time - 24.minutes).utc.to_datetime.iso8601(3),
        @time.utc.to_datetime.iso8601(3)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse last 1h & @fields.foo.@field=bar' do
    result = Peruse.search 'last 1h & @fields.foo.@field=bar'
    expected = Peruse::Helper.filter_builder(
      and: [
        Peruse::Helper.range_builder(
          (@time - 1.hour).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        Peruse::Helper.query_builder('@fields.foo.@field:bar')
      ]
    )
    expect(result).to eq(expected)
  end
end
