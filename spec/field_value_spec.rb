require 'spec_helper'

describe 'field / value searches' do
  it 'should parse a single field/value combo' do
    @parsed = @parser.parse 'tshark.http.@src_ip=bar'
    expect(@parsed[:field].to_s).to eq 'tshark.http.@src_ip'
    expect(@parsed[:value].to_s).to eq 'bar'
    expect(@parsed[:op].to_s).to eq '='
  end

  it 'should parse a single field / parenthesized value' do
    @parsed = @parser.parse 'ids.attacker=(10.150.44.195)'
    expect(@parsed[:field].to_s).to eq 'ids.attacker'
    expect(@parsed[:value].to_s).to eq '(10.150.44.195)'
    expect(@parsed[:op].to_s).to eq '='
  end
end
