require 'spec_helper'

describe 'the last command' do
  it 'should parse last 24h' do
    result = @transformer.apply @parser.parse('last 24h')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: 24.hours.ago.utc.to_datetime.iso8601(3),
          lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24d' do
    result = @transformer.apply @parser.parse('last 24d')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: 24.days.ago.utc.to_datetime.iso8601(3),
          lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24w' do
    result = @transformer.apply @parser.parse('last 24w')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: 24.weeks.ago.utc.to_datetime.iso8601(3),
          lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24s' do
    result = @transformer.apply @parser.parse('last 24s')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: 24.seconds.ago.utc.to_datetime.iso8601(3),
          lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24m' do
    result = @transformer.apply @parser.parse('last 24m')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: 24.minutes.ago.utc.to_datetime.iso8601(3),
          lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 1h @fields.foo.@field=bar' do
    result = @transformer.apply @parser.parse('last 1h @fields.foo.@field=bar')
    expect(result.query.to_s).to eq({query:{filtered:{
      query:{
        query_string: {
          query: '@fields.foo.field:bar'
      }},
      filter: {
        and: [
          range: {
            Plunk.timestamp_field => {
              gte: 1.hour.ago.utc.to_datetime.iso8601(3),
              lte: Time.now.utc.to_datetime.iso8601(3)
    }}]}}}}.to_s)
  end
end
