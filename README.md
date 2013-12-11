plunk
=====

Human-friendly query language for Elasticsearch

Examples:

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
