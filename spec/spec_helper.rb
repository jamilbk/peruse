require 'rspec'
require 'plunk'
require 'parslet/rig/rspec'

# Print ascii_tree when exception occurs
module Plunk
  class ParserWrapper < Parser
    def parse(query)
      begin
        super(query)
      rescue Parslet::ParseFailed => failure
        puts failure.cause.ascii_tree
      end
    end
  end
end

RSpec.configure do |config|
  config.before :all do
    
    # use wrapped parser to print better debugging info
    @parser = Plunk::ParserWrapper.new
    @transformer = Plunk::Transformer.new

    # configure test instance of Plunk to use wrapper parser
    Plunk.configure do |c|
      c.transformer = @transformer
      c.parser = @parser
    end

    # just return the built query, don't execute against Elasticsearch
    Plunk::ResultSet.stub(:eval).and_return(:query)
  end
end
