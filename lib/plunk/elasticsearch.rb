require 'json'
require 'rest-client'

# Wrapper for Elasticsearch API
class Plunk::Elasticsearch
  attr_accessor :host, :port, :fields

  def initialize(opts={})
    @scheme = opts[:scheme] || "http"
    @host = opts[:host] || "localhost"
    @port = opts[:port] || "9200"
    @size = opts[:size] || "10000"
    @endpoint = "#{@scheme}://#{@host}:#{@port}"
  end

  # Get list of all field mappings stored in ES
  # TODO: cache response from ES
  def available_fields
    uri = URI.escape "#{@endpoint}/_mapping"
    result = JSON.parse(RestClient.get(uri))

    @fields = {}
    Plunk::Elasticsearch.nested_values(result, 'properties')

    @fields
  end

  def active_record_errors_for(query)
    return " can't be blank." if query.blank?

    uri = URI.escape "#{@endpoint}/_validate/query?explain=true"
    response = RestClient.post(uri, Plunk::Elasticsearch.build_ES_validator(query))

    json = JSON.parse(response)

    json['valid'] ? nil : json['explanations'].collect { |exp| exp['error'] }
  end

  #
  # UTILITY METHODS
  #
  def self.search(query)
    uri = URI.escape "#{@endpoint}/_search?size=#{@size}"

    RestClient.post uri, build_ES_query(query)
  end

  # returns all values for all occurences of the given nested key
  def self.nested_values(hash, key)
    hash.each do |k, v|
      if k == key
        @fields.merge! v
      else
        nested_values(v, key) if v.is_a? Hash
      end
    end 
  end

  # nested field matcher
  def self.extract_values(hash, keys)
    @vals ||= []

    hash.each_pair do |k, v|
      if v.is_a? Hash
        extract_values(v, keys)
      elsif v.is_a? Array
        v.flatten!
        if v.first.is_a? Hash
          v.each { |el| extract_values(el, keys) }
        elsif keys.include? k
          @vals += v
        end
      elsif keys.include? k
        @vals << v
      end
    end

    return @vals
  end

  def self.build_ES_validator(query)
    if valid_json? query
      # Strip the top-level "query" paramter since ES doesn't expect it
      JSON.parse(query)['query'].to_json
    else
      <<-END
        {
          "query_string": {
            "query": "#{query}"
          }
        }
      END
    end
  end

  def self.build_ES_query(query)
    if valid_json? query
      query
    else
      <<-END
        {
          "query": {
            "query_string": {
              "query": "#{query}"
            }
          }
        }
      END
    end
  end

  def self.valid_json?(json)
    begin
      JSON.parse json
      true
    rescue JSON::ParserError
      false
    end
  end
end

