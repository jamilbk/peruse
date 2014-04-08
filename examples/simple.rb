$LOAD_PATH << './lib'
require './lib/plunk'

Plunk.configure do |c|
  c.elasticsearch_options = { host: 'localhost' }
  c.timestamp_field = :timestamp
end

query = 'window "last monday" to "last tuesday" & _type = syslog' 
puts Plunk.search query
