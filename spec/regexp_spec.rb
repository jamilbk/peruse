require 'spec_helper'

describe 'regexp searches' do

  it 'should parse foo=/blah foo/' do
    result = Plunk.search 'foo=/blah foo/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.regexp_builder(
        'foo',
        'blah foo'
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=/blah\/ foo/' do
    result = Plunk.search 'foo=/blah\/ foo/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.regexp_builder(
        'foo',
        'blah\/ foo'
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=/blah\. foo/' do
    result = Plunk.search 'foo=/blah\. foo/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.regexp_builder(
        'foo',
        'blah\. foo'
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse http.headers=/.*User\-Agent\: Microsoft\-WebDAV.*/' do
    result = Plunk.search 'http.headers=/.*User\-Agent\: Microsoft\-WebDAV.*/'
    expected = Plunk::Helper.filter_builder(
      Plunk::Helper.regexp_builder(
        'http.headers',
        '.*User\-Agent\: Microsoft\-WebDAV.*'
      )
    )
    expect(result).to eq(expected)
  end
end
