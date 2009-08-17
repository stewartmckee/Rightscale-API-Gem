require File.dirname(__FILE__) + '/../lib/server.rb'

describe Server do
  before(:each) do
    
  end

  it "should create, modify and delete a server" do

    original_nickname = "test server through api"

    d = Server.create(original_nickname, "This is a test deployment that has been created through the api")

    d.nickname.should == original_nickname
    d.nickname += "CHANGED"
    d.nickname.should == original_nickname + "CHANGED"
    d.save
    d.nickname.should == original_nickname + "CHANGED"
    d.nickname += "CHANGED AGAIN"
    d.nickname.should == original_nickname + "CHANGEDCHANGED AGAIN"
    d.update
    d.nickname.should == original_nickname + "CHANGED"

    d.delete

  end
end

