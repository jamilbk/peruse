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

  it 'should parse refactor' do
    to_parse = "((not command1 or (command2 and not (command3 or command4)) and not command5))"
    parsed = @parser.parse(to_parse)
    puts parsed
    # result = @transformer.apply parsed
    # puts result
  end

  it 'should parse stuff' do
    to_parse = "command1"
    parsed = @parser.parse(to_parse)
    puts parsed
  end
end
