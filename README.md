Plunk
=====

Human-friendly query language for Elasticsearch

Currently assumes you're using Logstash to 

## Installation
```
gem install plunk
```

## Usage
```ruby
require 'plunk'

# configure is required
# elasticsearch_options accepts the same params as Elasticsearch::Client
Plunk.configure do |config|
  config.elasticsearch_options = { host: 'localhost' }
end

# all documents of type syslog from the last week
Plunk.search 'last 1w _type = syslog'

# nested search. first runs the '_type=access_logs' search, extracts the values
# for fields user.name, user.nickname, and user.email, then ORs these together
# as the query for the outer search.
Plunk.search 'user = `_type=access_logs | user.name, user.nickname, user.email`'

# booleans are supported
Plunk.search 'foo.field = (bar OR baz)'
```


## Translation:

```last 24h _type=syslog```

gets translated to:

```json
{
  "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "_type:syslog"
        }
      },
      "filter": {
        "and": [
          {
            "range": {
              "timestamp": {
                "gte": "2013-08-23T05:43:13.770Z",
                "lte": "2013-08-24T05:43:13.770Z"
              }
            }
          }
        ]
      }
    }
  }
}
```
