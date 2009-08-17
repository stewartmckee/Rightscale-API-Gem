# To change this template, choose Tools | Templates
# and open the template in the editor.

class HttpUtils
  require 'open-uri'
  @@cookie = ""

  def get(url, email = nil, password = nil)
    puts "Requesting #{url}"
    uri = URI.parse(url)
    response = open(uri)

    #@@cookie = response['set-cookie']

    response.body
  end

  def post(url, request_data)
    # POST request -> logging in
    headers = {
      'Cookie' => @@cookie,
    }
    data = encode_post_data(request_data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    puts data
    puts headers
    resp = http.post(uri.path, data, headers)

    resp.body

  end

  def encode_post_data(data)
    data.map{|key, value| "#{key}=#{value}"}.join("&")
  end
end
