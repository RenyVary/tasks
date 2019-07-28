require "net/http"
require 'json'
p "Источник: https://www.coindesk.com/price/bitcoin"

def get_bitcoin
  uri = URI("https://api.coindesk.com/v1/bpi/currentprice/USD.json")
  response = nil
  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new uri
    response = http.request(request)
  end
end

def get_rate(response)
  if response.class == Net::HTTPOK
    accepted_hash = JSON.parse(response.body)
    accepted_hash["bpi"]["USD"]["rate"]
  else 
    "Undefinde error"
  end
end

def append_to_file(string)
  btc_file = File.open("BTC.txt", "a")
  btc_file.write "\n"   # допишем символ переноса на новую строку
  btc_file.write string # теперь допишем новый фрукт
  btc_file.close
end


last_rate = get_rate(get_bitcoin) 

loop do

  rate = get_rate(get_bitcoin)

  if last_rate < rate
  	puts "$" + rate + "⬈"
  elsif last_rate > rate
  	puts "$" + rate + "⬊"
  else
  	puts "$" + rate
  end

  append_to_file(rate)
  last_rate = rate
  sleep(20)
end
