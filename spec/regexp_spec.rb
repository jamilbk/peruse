require 'spec_helper'

describe 'regexp searches' do

  it 'should parse foo=/blah foo/' do
    result = Peruse.search 'foo=/blah foo/'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.regexp_builder(
        'foo',
        'blah foo'
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=/blah\/ foo/' do
    result = Peruse.search 'foo=/blah\/ foo/'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.regexp_builder(
        'foo',
        'blah\/ foo'
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse foo=/blah\. foo/' do
    result = Peruse.search 'foo=/blah\. foo/'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.regexp_builder(
        'foo',
        'blah\. foo'
      )
    )
    expect(result).to eq(expected)
  end

  it 'should parse http.headers=/.*User\-Agent\: Microsoft\-WebDAV.*/' do
    result = Peruse.search 'http.headers=/.*User\-Agent\: Microsoft\-WebDAV.*/'
    expected = Peruse::Helper.filter_builder(
      Peruse::Helper.regexp_builder(
        'http.headers',
        '.*User\-Agent\: Microsoft\-WebDAV.*'
      )
    )
    expect(result).to eq(expected)
  end
end
