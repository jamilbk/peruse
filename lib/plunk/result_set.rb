class Plunk::ResultSet
  attr_accessor :query

  def initialize(opts=nil)
    if opts
      @query = { query: { }}
      
      if @query_string = opts[:query_string]
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

  def raw_query
    @query_string
  end

  def eval
    @@elasticsearch.search(@query.to_json) if @query
  end
end
