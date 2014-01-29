require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'

describe 'the last command' do
  include_context "time stubs"
  include_context "plunk stubs"

  it 'should parse last 24h' do
    result = @transformer.apply @parser.parse('last 24h')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: (@time - 24.hours).utc.to_datetime.iso8601(3),
          lte: @time.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24d' do
    result = @transformer.apply @parser.parse('last 24d')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: (@time - 24.days).utc.to_datetime.iso8601(3),
          lte: @time.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24w' do
    result = @transformer.apply @parser.parse('last 24w')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: (@time - 24.weeks).utc.to_datetime.iso8601(3),
          lte: @time.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24s' do
    result = @transformer.apply @parser.parse('last 24s')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: (@time - 24.seconds).utc.to_datetime.iso8601(3),
          lte: @time.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 24m' do
    result = @transformer.apply @parser.parse('last 24m')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: (@time - 24.minutes).utc.to_datetime.iso8601(3),
          lte: @time.utc.to_datetime.iso8601(3)
    }}}}}}.to_s)
  end

  it 'should parse last 1h @fields.foo.@field=bar' do
    result = @transformer.apply @parser.parse('last 1h @fields.foo.@field=bar')
    expect(result.query.to_s).to eq({query:{filtered:{
      query:{
        query_string: {
          query: '@fields.foo.@field:bar'
      }},
      filter: {
        and: [
          range: {
            Plunk.timestamp_field => {
              gte: (@time - 1.hour).utc.to_datetime.iso8601(3),
              lte: @time.utc.to_datetime.iso8601(3)
    }}]}}}}.to_s)
  end
end
