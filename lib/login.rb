require 'rest_client'
require "base64"

class Login
  def initialize(id, email, password)

    RestClient.log = "tmp/restclient.log"

    auth = "#{email}:#{password}"
    auth =  Base64.encode64(auth)
    response = RestClient.head("https://my.rightscale.com/api/acct/#{id}/login?api_version=1.0", {:Authorization => "Basic #{auth}"})
    puts response
    cookie = response.headers[:set_cookie]
    puts cookie


  end
end
