
#   after :each do
#     transformed = @transformer.apply(@parsed)
#     if transformed.is_a? Array
#       transformed.map(&:class).uniq.should =~ Array(ResultSet)
#     else
#       transformed.should be_a ResultSet
#     end
#   end

