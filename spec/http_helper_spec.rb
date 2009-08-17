require File.dirname(__FILE__) + '/../lib/http_utils.rb'

describe HttpUtils do
  
  before(:each) do
    @http = HttpUtils.new
  end

  it "should perform a successful get" do
    data = @http.get("http://www.rockwellcottage.com/")
    data.include?("Welcome to rockwellcottage.com").should be_true
  end

  it "should perform a successful post" do
    request_data = {"test1" => "value1", "test2" => "value2"}
    response_data = @http.post("http://www.rockwellcottage.com/", request_data)

  end
end

