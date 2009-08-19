require File.dirname(__FILE__) + '/../lib/server_template.rb'
require File.dirname(__FILE__) + '/../lib/right_scale_api.rb'

describe ServerTemplate do
  before(:each) do
    @api = RightScaleApi.new
    @api.login
  end

  it "should return a list of available server templates" do
    templates = @api.server_templates
    templates.length.should be > 0
    templates.each do |template|
      template.name.should_not be_nil
      puts template.name
    end
  end
end

