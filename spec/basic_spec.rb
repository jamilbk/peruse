require 'spec_helper'

describe 'basic searches' do
  def basic_builder(expected)
    {
      query: {
        filtered: {
          filter: {
            query: {
              query_string: {
                query: expected
              }
            }
          }
        }
      }
    }
  end

  it 'should parse bar' do
    result = Plunk.search 'bar'
    result.should eq(basic_builder('bar'))
  end

  it 'should parse bar ' do
    result = Plunk.search 'bar '
    result.should eq(basic_builder('bar'))
  end

  it 'should parse (bar) ' do
    result = Plunk.search '(bar) '
    result.should eq(basic_builder('bar'))
  end
end
