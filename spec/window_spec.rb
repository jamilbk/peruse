require 'spec_helper'
require 'shared/time_stubs'
require 'shared/peruse_stubs'
require 'chronic'

describe 'the window command' do
  include_context 'time stubs'
  include_context 'peruse stubs'

  it 'should parse window 3/11/13 to 3/12/13' do
    result = Peruse.search 'window 3/11/13 to 3/12/13'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        Peruse::Helper.timestamp_format(Chronic.parse('3/11/13')),
        Peruse::Helper.timestamp_format(Chronic.parse('3/12/13'))
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse window "last monday" to "last thursday"' do
    result = Peruse.search 'window "last monday" to "last thursday"'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        Peruse::Helper.timestamp_format(Chronic.parse('last monday')),
        Peruse::Helper.timestamp_format(Chronic.parse('last thursday'))
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse window -60m to -30m' do
    result = Peruse.search 'window -60m to -30m'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.range_builder(
        Peruse::Helper.timestamp_format(@time - 60.minutes),
        Peruse::Helper.timestamp_format(@time - 30.minutes)
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse NOT window -60m to -30m' do
    result = Peruse.search 'NOT window -60m to -30m'
    expected = Peruse::Helper.filter_builder(
      not: 
        Peruse::Helper.range_builder(
          Peruse::Helper.timestamp_format(@time - 60.minutes),
          Peruse::Helper.timestamp_format(@time - 30.minutes)
        )
    )
    expect(result).to eq(expected)
  end
end
