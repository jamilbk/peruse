require 'spec_helper'

describe 'regexp searches' do
  context 'simple' do
    it 'should parse a basic regexp search' do
      @parsed = @parser.parse 'foo=/blah foo/'
      expect(@parsed[:field].to_s).to eq 'foo'
      expect(@parsed[:value].to_s).to eq '/blah foo/'
    end
  end

  context 'complex' do
    it 'should parse key/value with regex' do
      @parsed = @parser.parse 'foo=bar fe.ip=/whodunnit/'
      expect(@parsed[0][:field].to_s).to eq 'foo'
      expect(@parsed[0][:value].to_s).to eq 'bar'
      expect(@parsed[1][:field].to_s).to eq 'fe.ip'
      expect(@parsed[1][:value].to_s).to eq '/whodunnit/'
    end

    it 'should parse last command with a regex' do
      @parsed = @parser.parse 'last 24w foo=/blah/'
      expect(@parsed[:timerange][:quantity].to_s).to eq '24'
      expect(@parsed[:timerange][:quantifier].to_s).to eq 'w'
      expect(@parsed[:search][:field].to_s).to eq 'foo'
      expect(@parsed[:search][:value].to_s).to eq '/blah/'
    end
  end
end
