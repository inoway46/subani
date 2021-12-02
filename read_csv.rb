require "csv"

array = []

CSV.foreach("data.csv") do |row|
  array << row
end

p array