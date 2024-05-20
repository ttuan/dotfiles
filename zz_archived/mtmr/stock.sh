#!/usr/bin/ruby

require 'net/http'
require 'json'

class StockChecker
  # Puts stock symbol to this file with format: ACB,VNM,HPG
  STOCK_SYMBOLS_FILE_PATH="/Users/ttuan/.stock_symbols"

  def initialize
    @stock_symbols = File.read(STOCK_SYMBOLS_FILE_PATH).strip.split(",")
  end

  def run
    result = []

    # TODO: Only call API from 09-15
    stocks = stock_symbols.map {|symbol| Stock.new(symbol)}
    stocks.sort_by(&:percentage).reverse!.each do |stock|
      result << "#{color(stock)}#{stock.symbol}: #{stock.percentage}%\e[0m"
    end

    result.join(" | ")
  end

  private
  attr_reader :stock_symbols

  def color stock
    case
    when stock.cell?
      "\e[35m" # purple
    when stock.floor?
      "\e[34m" # blue
    when stock.increase?
      "\e[32m" # green
    when stock.not_change?
      "\e[33m" # yellow
    when stock.decrease?
      "\e[31m" # red
    end
  end
end

class Stock
  attr_reader :symbol, :yesterday_price, :today_price, :changable_price

  def initialize symbol
    @symbol = symbol
    @yesterday_price, @today_price = prices[-2..]
  end

  def percentage
    ((today_price - yesterday_price) / yesterday_price * 100).round(2)
  end

  def cell?
    cell_price = (yesterday_price + changable_price).round(2)
    today_price == cell_price
  end

  def floor?
    floor_price = (yesterday_price - changable_price).round(2)
    today_price == floor_price
  end

  def increase?
    today_price > yesterday_price
  end

  def decrease?
    today_price < yesterday_price
  end

  def not_change?
    today_price == yesterday_price
  end

  private
  def exchange
    url = "https://dchart-api.vndirect.com.vn/dchart/search?limit=1&type=stock&query=#{symbol}"
    response = request(url)

    # HOSE/HNX/UPCOM
    response[0][:exchange]
  end

  def prices
    start_time = (Time.now - 15 * 24 * 60 * 60).to_i
    end_time = Time.now.to_i

    url = "https://dchart-api.vndirect.com.vn/dchart/history?resolution=D&symbol=#{symbol}&from=#{start_time}&to=#{end_time}"
    response = request(url)

    response[:c]
  end

  def changable_price
    return @changable_price unless @changable_price.nil?

    case exchange
    when "HOSE"
      price_scale = (today_price > 50) ? 0.1 : (today_price < 10 ? 0.01 : 0.05)
      @changable_price = yesterday_price * 0.07 - ((yesterday_price * 0.07) % price_scale).round(4)
    when "HNX"
      price_scale = 0.1
      @changable_price = yesterday_price * 0.1 - ((yesterday_price * 0.1) % price_scale).round(4)
    when "UPCOM"
      price_scale = 0.1
      @changable_price = yesterday_price * 0.15 - ((yesterday_price * 0.15) % price_scale).round(4)
    end
  end

  def request url
    uri          = URI.parse url
    http         = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    req          = Net::HTTP::Get.new uri.request_uri
    response     = JSON.parse http.request(req).body, symbolize_names: true
  end
end

print StockChecker.new.run
