require File.dirname(__FILE__) + '/../lib/right_scale_api.rb'
require File.dirname(__FILE__) + '/../lib/server.rb'
require File.dirname(__FILE__) + '/../lib/ec2_ssh_key.rb'
require File.dirname(__FILE__) + '/../lib/server_template.rb'

describe Server do
  before(:each) do
    @api = RightScaleApi.new
  end

  it "should create a server" do
    server_template = nil
    @api.server_templates.each do |temp|
      server_template = temp if temp.name == "Rails all-in-one-developer v8"
    end
    ec2_ssh_key = EC2SSHKey.from_id("146407")
    ec2_security_group = @api.ec2_security_groups.first
    deployment = @api.deployments.first
    aki_image = nil
    ari_image = nil
    ec2_image = nil
    instance_type = nil
    s = Server.create("test server", server_template, ec2_ssh_key, ec2_security_group, deployment, aki_image, ari_image, ec2_image, instance_type)
    puts s.href
  end
end

