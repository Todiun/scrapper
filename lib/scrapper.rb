require 'net/http'
require 'json'
require 'nokogiri'
require 'dotenv/load'

API_KEY = ENV["API_KEY"] 

url = URI("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?limit=20&convert=USD")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["X-CMC_PRO_API_KEY"] = API_KEY
request["Accept"] = "application/json"

response = http.request(request)

if response.code == "200"
  data = JSON.parse(response.body)

  
  html_string = "<coins>"
  data["data"].each do |coin|
    html_string += "<coin>"
    html_string += "<symbol>#{coin['symbol']}</symbol>"
    html_string += "<name>#{coin['name']}</name>"
    html_string += "<price>#{coin['quote']['USD']['price'].round(2)}</price>"
    html_string += "</coin>"
  end
  html_string += "</coins>"

  
  doc = Nokogiri::XML(html_string)

  
  doc.xpath("//coin").each do |coin_node|
    symbol = coin_node.at_xpath("symbol").text
    name   = coin_node.at_xpath("name").text
    price  = coin_node.at_xpath("price").text
    puts "#{symbol} (#{name}) - $#{price}"
  end
else
  puts "Error: #{response.code} #{response.message}"
end
