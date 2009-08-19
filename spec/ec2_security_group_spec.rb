require File.dirname(__FILE__) + '/../lib/right_scale_api.rb'
require File.dirname(__FILE__) + '/../lib/ec2_security_group.rb'

describe EC2SecurityGroup do
  before(:each) do
    @api = RightScaleApi.new
  end

  it "should get specified ssh key" do
    key = EC2SSHKey.from_id("146407")
    key.aws_key_name.should_not be_nil
  end
end

