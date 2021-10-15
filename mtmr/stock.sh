#!/usr/bin/ruby

require 'net/http'
require 'json'

stock_symbols = File.read("/Users/ttuan/.stock_symbols").strip.split(",")

result = []

from = (Time.now - 48 * 60 * 60).to_i
to = Time.now.to_i

stock_symbols.each do |stock_symbol|
  url = "https://dchart-api.vndirect.com.vn/dchart/history?resolution=D&symbol=#{stock_symbol}&from=#{from}&to=#{to}"

  uri = URI.parse url
  http = Net::HTTP.new uri.host, uri.port
  http.use_ssl = true
  req = Net::HTTP::Get.new uri.request_uri
  response = JSON.parse http.request(req).body, symbolize_names: true

  yesterday_price = response[:c][0]
  today_price     = response[:c][1]

  current_percentage_change = ((today_price - yesterday_price) / yesterday_price * 100).round(2)

  change = "#{stock_symbol}: #{current_percentage_change}%"
  result << (today_price > yesterday_price ? "\e[32m#{change}\e[0m" : "\e[31m#{change}\e[0m")
end

print result.join(" | ")
