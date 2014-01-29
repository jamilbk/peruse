require 'spec_helper'
require 'shared/time_stubs'
require 'shared/plunk_stubs'

describe 'nested searches' do
  include_context "time stubs"
  include_context "plunk stubs"
  
  before :each do
    fake_results = {
      foo: 'bar',
      baz: 5,
      arr: [ 0, 1, 2, 3 ],
      :timestamp => @time
    }.to_json
    Plunk::ResultSet.any_instance.stub(:eval).and_return(fake_results)
  end

  it 'should transform' do
    results = @transformer.apply @parser.parse('foo=`bar=baz|baz,fass,fdsd`')
    expect(results.query).to eq({query:{filtered:{query:{query_string:{
      query: 'foo:(5)'
    }}}}})
  end

  it 'should parse a nested basic search' do
    @parsed = @parser.parse 'tshark.len = ` 226 | tshark.frame.time_epoch,tshark.ip.src`'
    expect(@parsed[:field].to_s).to eq 'tshark.len'
    expect(@parsed[:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:match].to_s).to eq '226'
    expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
  end

  it 'should parse a nested regexp' do
    @parsed = @parser.parse 'tshark.len = ` cif.malicious_ips=/foo/ | tshark.frame.time_epoch,tshark.ip.src`'
    expect(@parsed[:field].to_s).to eq 'tshark.len'
    expect(@parsed[:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:field].to_s).to eq 'cif.malicious_ips'
    expect(@parsed[:value][:initial_query][:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:value].to_s).to eq '/foo/'
    expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
  end

  it 'should parse a nested basic boolean' do
    @parsed = @parser.parse 'tshark.len = `(foo OR bar) | tshark.frame.time_epoch,tshark.ip.src`'
    expect(@parsed[:field].to_s).to eq 'tshark.len'
    expect(@parsed[:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:match].to_s).to eq '(foo OR bar) '
    expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
  end

  it 'should parse a nested field / value boolean' do
    @parsed = @parser.parse 'tshark.len = `baz=(foo OR bar AND (bar OR fez)) | tshark.frame.time_epoch,tshark.ip.src`'
    expect(@parsed[:field].to_s).to eq 'tshark.len'
    expect(@parsed[:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:field].to_s).to eq 'baz'
    expect(@parsed[:value][:initial_query][:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:value].to_s).to eq '(foo OR bar AND (bar OR fez)) '
    expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
  end

  it 'should parse a nested last standalone timerange' do
    @parsed = @parser.parse 'tshark.len = `last 24h | tshark.frame.time_epoch,tshark.ip.src`'
    expect(@parsed[:field].to_s).to eq 'tshark.len'
    expect(@parsed[:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:timerange][:quantity].to_s).to eq '24'
    expect(@parsed[:value][:initial_query][:timerange][:quantifier].to_s).to eq 'h'
    expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
  end

  it 'should parse a nested last timerange and field / value pair' do
    @parsed = @parser.parse 'tshark.len = `last 24h foo=bar | tshark.frame.time_epoch,tshark.ip.src`'
    expect(@parsed[:field].to_s).to eq 'tshark.len'
    expect(@parsed[:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:timerange][:quantity].to_s).to eq '24'
    expect(@parsed[:value][:initial_query][:timerange][:quantifier].to_s).to eq 'h'
    expect(@parsed[:value][:initial_query][:search][:field].to_s).to eq 'foo'
    expect(@parsed[:value][:initial_query][:search][:op].to_s).to eq '='
    expect(@parsed[:value][:initial_query][:search][:value].to_s).to eq 'bar'
    expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
  end
end
