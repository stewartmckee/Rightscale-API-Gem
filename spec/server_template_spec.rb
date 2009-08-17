require File.dirname(__FILE__) + '/../lib/server_template.rb'
require File.dirname(__FILE__) + '/../lib/right_scale_api.rb'

describe ServerTemplate do
  before(:each) do
    @api = RightScaleApi.new
    @api.login
  end

  it "should return a list of available server templates" do
    @api.server_templates.length.should be > 0
  end
end

