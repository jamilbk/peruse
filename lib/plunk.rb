require 'elasticsearch'

class Plunk
  def self.configure(&block)
    puts "configure called!"
    class_eval(&block)

    initialize_elasticsearch
  end

  def self.initialize_elasticsearch
    @client = Elasticsearch::Client.new @elasticsearch_options
  end
end
