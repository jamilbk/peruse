require 'spec_helper'
require 'shared/time_stubs'
require 'shared/peruse_stubs'

describe 'chained searches' do
  include_context "time stubs"
  include_context "peruse stubs"

  it 'should parse last 24h & foo_type=bar & baz="fez" & host=27.224.123.110' do
    result = Peruse.search 'last 24h & foo_type=bar & baz="fez" & host=27.224.123.110'
    expected = Peruse::Helper.filter_builder({
      and: [
        Peruse::Helper.range_builder(
          (@time - 24.hours).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        Peruse::Helper.query_builder('foo_type:bar'),
        Peruse::Helper.query_builder('baz:"fez"'),
        Peruse::Helper.query_builder('host:27.224.123.110')
      ]
    })
    expect(result).to eq(expected)
  end

  it 'should parse last 24h & (foo_type=bar AND baz="fez" AND host=27.224.123.110)' do
    result = Peruse.search 'last 24h & (foo_type=bar AND baz="fez" AND host=27.224.123.110)'
    expected = Peruse::Helper.filter_builder({
      and: [
        Peruse::Helper.range_builder(
          (@time - 24.hours).utc.to_datetime.iso8601(3),
          @time.utc.to_datetime.iso8601(3)
        ),
        Peruse::Helper.query_builder('foo_type:bar'),
        Peruse::Helper.query_builder('baz:"fez"'),
        Peruse::Helper.query_builder('host:27.224.123.110')
      ]
    })
    expect(result).to eq(expected)
  end
end
