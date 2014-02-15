Plunk
=====

Human-friendly query language for Elasticsearch

## About

Plunk is a ruby gem to take a human-friendly search command and translate it
to something Elasticsearch understands. Currently it only supports a few
commands, but the framework is in place

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


## Translation

Plunk takes your command and translates

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

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/elbii/plunk/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
