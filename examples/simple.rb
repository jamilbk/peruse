$LOAD_PATH << './lib'
require './lib/peruse'

Peruse.configure do |c|
  c.elasticsearch_options = { host: 'localhost' }
  c.timestamp_field = :timestamp
end

query = 'window "last monday" to "last tuesday" & _type = syslog' 
puts Peruse.search query
