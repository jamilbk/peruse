require_relative 'elasticsearch'

class Plunk::ResultSet
  attr_accessor :query

  def initialize(opts=nil)
    if opts
      @query = { query: { }}
      
      if opts[:query_string]
        @query[:query][:query_string] = { query: opts[:query_string] }
      end

      if opts[:start_time] and opts[:end_time]
        @query[:query][:range] = {
          '@timestamp' => {
            gte: opts[:start_time],
            lte: opts[:end_time]
          }
        }
      end
    end
  end

  def *(rs)
    self.join(rs)
  end

  def join(rs)
    Plunk::ResultSet.new("[ #{@query} * #{rs.query} ]")
  end

  def eval(elasticsearch_recursor)
    return unless @query
    elasticsearch_recursor.search(@query.to_json)
  end
end

