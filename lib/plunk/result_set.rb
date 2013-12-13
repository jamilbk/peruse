module Plunk
  class ResultSet
    attr_accessor :query, :query_string

    def initialize(opts={})
      @query = { query: { filtered: {}}}

      if opts.size >= 3 # use "and" filter to AND filters
        @query_string = opts[:query_string]
        @query[:query][:filtered][:query] = {
          query_string: {
            query: opts[:query_string] }}
        @query[:query][:filtered][:filter] = {
          and: [
            range: {
              '@timestamp' => {
                gte: opts[:start_time],
                lte: opts[:end_time] }}]}
      else
        if @query_string = opts[:query_string]
          @query[:query][:filtered][:query] = {
            query_string: {
              query: opts[:query_string] }}
        elsif opts[:start_time] and opts[:end_time]
          @query[:query][:filtered][:query] = {
            range: {
              '@timestamp' => {
                gte: opts[:start_time],
                lte: opts[:end_time] }}}
        end
      end
    end

    def eval
      Plunk.elasticsearch_client.search(
        body: @query.to_json,
        size: Plunk.max_number_of_hits || 10
      ).to_json if @query
    end
  end
end
