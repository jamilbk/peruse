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
    @parser = Plunk::ParserWrapper.new
    @transformer = Plunk::Transformer.new
  end
end
