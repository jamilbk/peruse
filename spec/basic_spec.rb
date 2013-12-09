require 'spec_helper'

describe 'basic searches' do
  before :each do
    @parsed = @parser.parse 'bar'
  end

  it 'should parse a single keyword' do
    expect(@parsed[:match].to_s).to eq 'bar'
  end

  context 'transformed' do
    before :each do
      @result_set = @transformer.apply(@parsed)
    end

    it 'should be a proper query' do
      @result_set.query.should eq({
       query: {
         query_string: {
           query: 'bar'
      }}})
    end
  end
end
