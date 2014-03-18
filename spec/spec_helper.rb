require 'rspec'
require 'plunk'
require 'parslet/rig/rspec'
require 'shared/dummy_client'

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
    
    # configure test instance of Plunk to use wrapper parser
    Plunk.configure do |c|
      c.parser = Plunk::ParserWrapper.new
      c.transformer = Plunk::Transformer.new
    end
  end
end
