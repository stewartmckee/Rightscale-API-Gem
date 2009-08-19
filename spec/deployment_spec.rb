require File.dirname(__FILE__) + '/../lib/deployment.rb'

describe Deployment do
  before(:each) do
    
  end

  it "should create, modify and delete a deployment" do

    original_name = "test deployment through api"

    d = Deployment.create(original_name, "This is a test deployment that has been created through the api")

    d.name.should == original_name
    d.name += "CHANGED"
    d.name.should == original_name + "CHANGED"
    d.save
    d.name.should == original_name + "CHANGED"
    d.name += "CHANGED AGAIN"
    d.name.should == original_name + "CHANGEDCHANGED AGAIN"
    d.update
    d.name.should == original_name + "CHANGED"

    d.delete

  end

  it "should get list of deployments from api" do
    api = RightScaleApi.new
    api.deployments.each do |deployment|
      puts deployment.name
    end
  end
end

