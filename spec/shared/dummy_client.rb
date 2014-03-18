# Dummy Elasticsearch Client for specs

module Elasticsearch
  module Transport
    class Client
      def initialize(opts)
      end

      def search(payload)
        payload[:body]
      end
    end
  end
end
