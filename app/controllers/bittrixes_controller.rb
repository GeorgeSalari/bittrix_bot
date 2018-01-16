class BittrixesController < ApplicationController
  def bitrix_api_respons
    respons = api_query("GetMarketOrders", [5121])
    result = JSON.parse(respons)
    @procent = calc_procent(result['Data']['Sell'][0]["Price"], result['Data']['Buy'][0]["Price"])
  end

  def place_buy_order
    respons = api_query("SubmitTrade", {'Market': "XBY/BTC", 'Type': "Buy", 'Rate': 0.00002500, 'Amount': 30})
  end

  def api_query( method, req = {} )
    public_set = Set[ "GetCurrencies", "GetTradePairs", "GetMarkets", "GetMarket", "GetMarketHistory", "GetMarketOrders" ]
    private_set = Set[ "GetBalance", "GetDepositAddress", "GetOpenOrders", "GetTradeHistory", "GetTransactions", "SubmitTrade", "CancelTrade", "SubmitTip" ]
    if public_set.include?( method )
            url = 'https://www.cryptopia.co.nz/api/' + method
            if req
                    for param in req
                            url += '/' + param.to_s
                    end
            end
            uri = URI( url )
            r = Net::HTTP::Get.new( uri.path, initheader = {'Content-Type' =>'application/json'})
    elsif private_set.include?( method )
            url = "https://www.cryptopia.co.nz/Api/" + method
            uri = URI( url )
            nonce = Time.now.to_i.to_s
            post_data = req.to_json.to_s
            md5 = Digest::MD5.new.digest( post_data )
            requestContentBase64String = Base64.encode64( md5 )
            signature = ( ENV["CRYPTOPIA_API_KEY"] + "POST" + CGI::escape( url ).downcase + nonce + requestContentBase64String ).strip
            hmac_raw = OpenSSL::HMAC.digest('sha256', Base64.decode64( ENV["CRYPTOPIA_API_SECRET"] ), signature )
            hmacsignature = Base64.encode64( OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Base64.decode64( ENV["CRYPTOPIA_API_SECRET"] ), signature) ).strip
            header_value = "amx " + ENV["CRYPTOPIA_API_KEY"] + ":" + hmacsignature + ":" + nonce
            r = Net::HTTP::Post.new(uri.path)
            r.body = req.to_json
            r["Authorization"] = header_value
            r["Content-Type"] = "application/json; charset=utf-8"
    end
    sleep(1)
    https = Net::HTTP.new( uri.host, uri.port )
    https.use_ssl = true
    r["User-Agent"] = "Mozilla/4.0 (compatible; Cryptopia.co.nz API Ruby client)"
    res = https.request( r )
    return res.body
  end
end
