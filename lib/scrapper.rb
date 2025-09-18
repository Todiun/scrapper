require 'nokogiri'
require 'open-uri'


url= "https://coinmarketcap.com/all/views/all/"
page = Nokogiri::HTML(URI.open(url))

puts page.class

page.css('tr').first(20).each do |row|
  name  = row.css('td.cmc-table__cell--sort-by__name a').text.strip
  price = row.css('td.cmc-table__cell--sort-by__price a').text.strip
  puts "#{name} - #{price}" unless name.empty?
end