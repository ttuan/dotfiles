#!/usr/bin/ruby

require 'net/http'
require 'json'
require 'thwait'

class CoinChecker
  COIN_SYMBOLS_FILE_PATH="/Users/ttuan/.coin_symbols"

  def initialize
    @coin_symbols = File.read(COIN_SYMBOLS_FILE_PATH).strip.split(",")
  end

  def run
    results = []

    coin_symbols.each do |symbol|
      promises = []

      promises << Thread.new do
        url = "https://api.binance.com/api/v3/ticker/price?symbol=#{symbol}USDT"
        response = request(url)

        "#{symbol}$: #{response[:price].to_f.round(4)}"
      end

      ThreadsWait.all_waits(promises) do |t|
        results << t.value
      end
    end

    results.join(" | ")
  end

  private
  attr_reader :coin_symbols

  def request url
    uri          = URI.parse url
    http         = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    req          = Net::HTTP::Get.new uri.request_uri
    response     = JSON.parse http.request(req).body, symbolize_names: true
  end
end

print CoinChecker.new.run
