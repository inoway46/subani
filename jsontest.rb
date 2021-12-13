require 'open-uri'
require 'json'

heroes_json = URI.open('https://abema.tv/video/title/149-11').read
heroes_array = JSON.parse(heroes_json)
pp heroes_array
puts heroes_array.first['name']