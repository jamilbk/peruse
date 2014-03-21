require 'elasticsearch'

require 'plunk/helper'
require 'plunk/utils'
require 'plunk/parser'
require 'plunk/transformer'
require 'plunk/result_set'

module Plunk
  class << self
    attr_accessor :elasticsearch_options, :elasticsearch_client,
      :parser, :transformer, :max_number_of_hits, :timestamp_field, :logger
  end

  def self.configure(&block)
    class_eval(&block)
    self.timestamp_field ||= :timestamp
    initialize_parser
    initialize_transformer
    initialize_elasticsearch
  end

  def self.initialize_elasticsearch
    self.elasticsearch_client ||= Elasticsearch::Client.new(elasticsearch_options)
  end

  def self.initialize_parser
    self.parser ||= Parser.new
  end

  def self.initialize_transformer
    self.transformer ||= Transformer.new
  end

  def self.search(query_string)
    parsed = parser.parse query_string
    transformed = transformer.apply parsed

    if self.logger
      self.logger.debug "Query String: #{query_string}"
      self.logger.debug "Parsed Output: #{transformed}" 
    end

    ResultSet.new(transformed).eval
  end
end
