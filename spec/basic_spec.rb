require 'spec_helper'

describe 'basic searches' do
  def basic_builder(expected)
    {
      query: {
        filtered: {
          filter: {
            and: [
              {
                query: {
                  query_string: {
                    query: expected
                  }
                }
              }
            ]
          }
        }
      }
    }
  end

  it 'should parse bar' do
    result = @transformer.apply @parser.parse('bar')
    result.query.should eq(basic_builder('bar'))
  end

  it 'should parse bar ' do
    result = @transformer.apply @parser.parse('bar ')
    result.query.should eq(basic_builder('bar'))
  end

  it 'should parse (bar) ' do
    result = @transformer.apply @parser.parse('bar ')
    result.query.should eq(basic_builder('bar'))
  end
end
