require File.dirname(__FILE__) + '/../lib/right_scale_api.rb'

describe RightScaleApi do
  before(:each) do
    @api = RightScaleApi.new
  end

  it "should login successfully" do
    @api.login
  end
end

describe RightScaleApi do
  before(:each) do
    @api = RightScaleApi.new
    @api.login
  end

  it "should get list of servers" do
    @api.servers.should_not be_nil
  end
  it "should get list of deployments" do
    @api.deployments.should_not be_nil
  end
  it "should get list of statuses" do
    @api.statuses.should_not be_nil
  end
  it "should get list of alert_specs" do
    @api.alert_specs.should_not be_nil
  end
  it "should get list of ec2_ebs_volumes" do
    @api.ec2_ebs_volumes.should_not be_nil
  end
  it "should get list of ec2_ebs_snapshots" do
    @api.ec2_ebs_snapshots.should_not be_nil
  end
  it "should get list of ec2_elastic_ips" do
    @api.ec2_elastic_ips.should_not be_nil
  end
  it "should get list of ec2_security_groups" do
    @api.ec2_security_groups.should_not be_nil
  end
  it "should get list of ec2_ssh_keys" do
    @api.ec2_ssh_keys.should_not be_nil
  end
  it "should get list of server_arrays" do
    @api.server_arrays.should_not be_nil
  end
  it "should get list of server_templates" do
    @api.server_templates.should_not be_nil
  end
  it "should get list of right_scripts" do
    @api.right_scripts.should_not be_nil
  end
  it "should get list of macros" do
    @api.macros.should_not be_nil
  end
  it "should get list of credentials" do
    creds = @api.credentials
    puts creds
    creds.should_not be_nil
  end



end

