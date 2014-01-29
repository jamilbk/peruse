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
          gte: @time - 24.hours,
          lte: @time
    }}}}}}.to_s)
  end

  it 'should parse last 24d' do
    result = @transformer.apply @parser.parse('last 24d')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: @time - 24.days,
          lte: @time
    }}}}}}.to_s)
  end

  it 'should parse last 24w' do
    result = @transformer.apply @parser.parse('last 24w')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: @time - 24.weeks,
          lte: @time
    }}}}}}.to_s)
  end

  it 'should parse last 24s' do
    result = @transformer.apply @parser.parse('last 24s')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: @time - 24.seconds,
          lte: @time
    }}}}}}.to_s)
  end

  it 'should parse last 24m' do
    result = @transformer.apply @parser.parse('last 24m')
    expect(result.query.to_s).to eq({query:{filtered:{query:{
      range: {
        Plunk.timestamp_field => {
          gte: @time - 24.minutes,
          lte: @time
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
              gte: @time - 1.hour,
              lte: @time
    }}]}}}}.to_s)
  end
end
