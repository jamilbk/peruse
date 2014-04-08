require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'
require 'chronic'

describe 'the window command' do
  include_context 'time stubs'
  include_context 'plunk stubs'

  it 'should parse window 3/11/13 to 3/12/13' do
    result = Plunk.search 'window 3/11/13 to 3/12/13'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        Plunk::Helper.timestamp_format(Chronic.parse('3/11/13')),
        Plunk::Helper.timestamp_format(Chronic.parse('3/12/13'))
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse window "last monday" to "last thursday"' do
    result = Plunk.search 'window "last monday" to "last thursday"'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        Plunk::Helper.timestamp_format(Chronic.parse('last monday')),
        Plunk::Helper.timestamp_format(Chronic.parse('last thursday'))
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse window -60m to -30m' do
    result = Plunk.search 'window -60m to -30m'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.range_builder(
        Plunk::Helper.timestamp_format(@time - 60.minutes),
        Plunk::Helper.timestamp_format(@time - 30.minutes)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse NOT window -60m to -30m' do
    result = Plunk.search 'NOT window -60m to -30m'
    expected = Plunk::Helper.filter_builder(
      not: 
        Plunk::Helper.range_builder(
          Plunk::Helper.timestamp_format(@time - 60.minutes),
          Plunk::Helper.timestamp_format(@time - 30.minutes)
        )
    )
    expect(result).to eq(expected)
  end
end
