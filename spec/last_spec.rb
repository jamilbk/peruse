require 'spec_helper'

describe 'the last command' do
  context 'basic' do
    it 'should parse a standalone last command' do
      @parsed = @parser.parse 'last 24h'
      expect(@parsed[:timerange][:quantity].to_s).to eq '24'
      expect(@parsed[:timerange][:quantifier].to_s).to eq 'h'
    end
  end

  context 'complex' do
    before :all do
      @parsed = @parser.parse 'last 24w tshark.@src_ip = bar'
    end

    it 'should parse last command with a search' do
      expect(@parsed[:timerange][:quantity].to_s).to eq '24'
      expect(@parsed[:timerange][:quantifier].to_s).to eq 'w'
      expect(@parsed[:search][:field].to_s).to eq 'tshark.@src_ip'
      expect(@parsed[:search][:value].to_s).to eq 'bar'
    end

    context 'transformation' do
      before :each do
        @result_set = @transformer.apply(@parsed)
      end

      it 'should have the proper result set' do
        @result_set.should be_a Plunk::ResultSet
        @result_set.query.should be_present

        query = { query: {
          query_string: {
            query: "tshark.@src_ip:bar"
            },
          range: {
            '@timestamp' => {
              gte: 24.weeks.ago,
              lte: Time.now 
          }}}}

        @result_set.query.to_json.should eq query.to_json
      end
    end
  end
end
