require 'spec_helper'

describe 'the last command' do
  it 'should parse last 24h' do
    result = @transformer.apply @parser.parse('last 24h')
    puts "QUERY: #{result.query}"
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.hours.ago.utc.to_datetime.iso8601(3),
            lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}.to_s)
  end

  it 'should parse last 24d' do
    result = @transformer.apply @parser.parse('last 24d')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.days.ago.utc.to_datetime.iso8601(3),
            lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}.to_s)
  end

  it 'should parse last 24w' do
    result = @transformer.apply @parser.parse('last 24w')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.weeks.ago.utc.to_datetime.iso8601(3),
            lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}.to_s)
  end

  it 'should parse last 24s' do
    result = @transformer.apply @parser.parse('last 24s')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.seconds.ago.utc.to_datetime.iso8601(3),
            lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}.to_s)
  end

  it 'should parse last 24m' do
    result = @transformer.apply @parser.parse('last 24m')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.minutes.ago.utc.to_datetime.iso8601(3),
            lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}.to_s)
  end

  it 'should parse foo=bar last 1h' do
    result = @transformer.apply @parser.parse('last 1h foo=bar')
    expect(result.query.to_s).to eq({
      query: {
        query_string: {
          query: 'foo:bar'
        },
        range: {
          '@timestamp' => {
            gte: 1.hour.ago.utc.to_datetime.iso8601(3),
            lte: Time.now.utc.to_datetime.iso8601(3)
    }}}}.to_s)
  end
end
