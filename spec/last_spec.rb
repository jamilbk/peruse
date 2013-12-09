require 'spec_helper'

describe 'the last command' do
  it 'should parse last 24h' do
    result = @transformer.apply @parser.parse('last 24h')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.hours.ago,
            lte: Time.now
    }}}}.to_s)
  end

  it 'should parse last 24d' do
    result = @transformer.apply @parser.parse('last 24d')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.days.ago,
            lte: Time.now
    }}}}.to_s)
  end

  it 'should parse last 24w' do
    result = @transformer.apply @parser.parse('last 24w')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.weeks.ago,
            lte: Time.now
    }}}}.to_s)
  end

  it 'should parse last 24s' do
    result = @transformer.apply @parser.parse('last 24s')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.seconds.ago,
            lte: Time.now
    }}}}.to_s)
  end

  it 'should parse last 24m' do
    result = @transformer.apply @parser.parse('last 24m')
    expect(result.query.to_s).to eq({
      query: {
        range: {
          '@timestamp' => {
            gte: 24.minutes.ago,
            lte: Time.now
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
            gte: 1.hour.ago,
            lte: Time.now
    }}}}.to_s)
  end
end
