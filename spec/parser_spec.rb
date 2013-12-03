require 'plunk'
require 'plunk/parser'

# Print ascii_tree when exception occurs
class Plunk::ParserWrapper < Plunk::Parser
  def parse(query)
    begin
      super(query)
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end
end

describe Plunk::Parser do
  before :all do
    @parser = Plunk::ParserWrapper.new
    @transformer = Plunk::Transformer.new
  end

  context 'single-query searches' do
    it 'should parse a single keyword' do
      @parsed = @parser.parse 'bar'
      expect(@parsed[:match].to_s).to eq 'bar'
    end

    it 'should parse a single field/value combo' do
      @parsed = @parser.parse 'tshark.http.@src_ip=bar'
      expect(@parsed[:field].to_s).to eq 'tshark.http.@src_ip'
      expect(@parsed[:value].to_s).to eq 'bar'
      expect(@parsed[:op].to_s).to eq '='
    end

    it 'should parse a single boolean expression' do
      @parsed = @parser.parse '(bar OR car)'
      expect(@parsed[:match].to_s).to eq '(bar OR car)'
    end

    it 'should parse a single field / value complex boolean expression' do
      @parsed = @parser.parse 'ids.attackers=(bar OR car)'
      expect(@parsed[:field].to_s).to eq 'ids.attackers'
      expect(@parsed[:value].to_s).to eq '(bar OR car)'
      expect(@parsed[:op].to_s).to eq '='
    end

    it 'should parse a single field / parenthesized value' do
      @parsed = @parser.parse 'ids.attacker=(10.150.44.195)'
      expect(@parsed[:field].to_s).to eq 'ids.attacker'
      expect(@parsed[:value].to_s).to eq '(10.150.44.195)'
      expect(@parsed[:op].to_s).to eq '='
    end

    it 'should parse a basic regex search' do
      @parsed = @parser.parse 'foo=/blah foo/'
      expect(@parsed[:field].to_s).to eq 'foo'
      expect(@parsed[:value].to_s).to eq '/blah foo/'
    end

    context 'the last command' do
      before :each do
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

    context 'chained searches' do
      it 'should parse last command with a regex' do
        @parsed = @parser.parse 'last 24w foo=/blah/'
        expect(@parsed[:timerange][:quantity].to_s).to eq '24'
        expect(@parsed[:timerange][:quantifier].to_s).to eq 'w'
        expect(@parsed[:search][:field].to_s).to eq 'foo'
        expect(@parsed[:search][:value].to_s).to eq '/blah/'
      end
    end

    it 'should parse last command with boolean' do
      @parsed = @parser.parse 'last 1h (foo OR bar)'
      expect(@parsed[:search][:match].to_s).to eq '(foo OR bar)'
    end

    it 'should parse key/value with regex' do
      @parsed = @parser.parse 'foo=bar fe.ip=/whodunnit/'
      expect(@parsed[0][:field].to_s).to eq 'foo'
      expect(@parsed[0][:value].to_s).to eq 'bar'
      expect(@parsed[1][:field].to_s).to eq 'fe.ip'
      expect(@parsed[1][:value].to_s).to eq '/whodunnit/'
    end
  end

  context 'nested search' do
    it 'should parse the nested search' do
      @parsed = @parser.parse 'tshark.len = ` 226 | tshark.frame.time_epoch,tshark.ip.src`'
      expect(@parsed[:field].to_s).to eq 'tshark.len'
      expect(@parsed[:op].to_s).to eq '='
      expect(@parsed[:value][:term].to_s).to eq '226 '
      expect(@parsed[:value][:extractors].to_s).to eq 'tshark.frame.time_epoch,tshark.ip.src'
    end
  end
end
