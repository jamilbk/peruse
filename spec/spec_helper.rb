require 'rspec'
require 'peruse'
require 'parslet/rig/rspec'
require 'shared/dummy_client'

# Print ascii_tree when exception occurs
module Peruse
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
    
    # configure test instance of Peruse to use wrapper parser
    Peruse.configure do |c|
      c.parser = Peruse::ParserWrapper.new
      c.transformer = Peruse::Transformer.new
    end
  end
end
