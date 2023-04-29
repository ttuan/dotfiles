#!/usr/bin/ruby

class Quote
  QUOTE_FILE_PATH="/Users/ttuan/.quote"

  def initialize
    @quotes = File.read(QUOTE_FILE_PATH).strip.split(",")
  end

  def run
    colors = ["\e[35m", "\e[32m", "\e[33m", "\e[31m"]

    "#{colors.sample}#{quotes.sample}\e[0m"
  end

  private
  attr_reader :quotes
end

print Quote.new.run
