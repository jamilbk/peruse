require 'rspec'
require 'plunk'
require 'plunk/parser'
require 'plunk/transformer'
require 'plunk/result_set'
require 'plunk/elasticsearch'
require 'parslet/rig/rspec'

# Print ascii_tree when exception occurs
class Plunk::ParserWrapper < Plunk::Parser
  def parse(query)
    begin
      super(query)
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end
end

RSpec.configure do |config|
  config.before :all do
    @parser = Plunk::ParserWrapper.new
    @transformer = Plunk::Transformer.new
  end
end
