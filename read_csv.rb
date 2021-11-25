require "csv"

array = []

CSV.foreach("data.csv") do |row|
  array << row
end

integers = array.map{|n| n.to_i}

p integers