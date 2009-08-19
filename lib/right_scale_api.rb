require 'rest_client'
require 'base64'
require 'json'
require 'xml'
require 'yaml'

require File.dirname(__FILE__) + '/deployment.rb'
require File.dirname(__FILE__) + '/server.rb'
require File.dirname(__FILE__) + '/server_template.rb'
require File.dirname(__FILE__) + '/ec2_security_group.rb'

class RightScaleApi
  RestClient.log = "tmp/restclient.log"
  attr_accessor :session, :id

  def initialize()
    @config = YAML.load(File.open(File.dirname(__FILE__) + '/../config.yml'))
    self.id = @config["credentials"]["id"]
  end

  def login()
    auth = "#{@config["credentials"]["email"]}:#{@config["credentials"]["password"]}"
    auth =  Base64.encode64(auth)
    response = RestClient.head(get_url("login"), {"X-API-VERSION" => "1.0", :Authorization => "Basic #{auth}"})
    self.session = response.headers[:set_cookie]
    self.session
  end

  def deployments
    deployments = []
    get("deployments.js").each do |d|
      deployments << Deployment.new(d["nickname"], d["description"], d["href"], d["created_at"], d["updated_at"])
    end
    deployments
  end
  def servers
    servers = []
    get("servers.js").each do |s|
      puts "--- #{s}"
      #servers << Server.new()
    end
    servers
  end
  def statuses
    #get("statuses.js")
  end
  def alert_specs
    get("deployments.js")
  end
  def ec2_ebs_volumes
    get("ec2_ebs_volumes.js")
  end
  def ec2_ebs_snapshots
    get("ec2_ebs_snapshots.js")
  end
  def ec2_elastic_ips
    get("ec2_elastic_ips.js")
  end
  def ec2_security_groups
    ec2_security_groups = []
    get("ec2_security_groups.js").each do |group|
      ec2_security_groups << EC2SecurityGroup.new(group["aws_description"], group["aws_group_name"], group["aws_perms"])
    end
    ec2_security_groups
  end
  def server_arrays
    #get("server_arrays.js")
  end
  def server_templates
    server_templates = []
    get("server_templates.js").each do |template|
      server_templates << ServerTemplate.new(template["nickname"],template["description"],template["href"],template["updated_at"])
    end
    server_templates
  end
  def right_scripts
    login() if self.session.nil?
    xml = RestClient.get(get_url("right_scripts.xml"), {"X-API-VERSION" => "1.0", :cookie => self.session})
    parser = XML::Parser.string(xml)
    doc = parser.parse
    scripts = []
    doc.find('//right-script').each do |s|
      scripts << {"name" => s.find("name").first.content,
                "description" => s.find("description").first.content,
                "script" => s.find("script").first.content,
                "created-at" => s.find("created-at").first.content,
                "updated-at" => s.find("updated-at").first.content}
    end
    scripts
  end
  def macros
    get("macros.js")
  end
  def credentials
    login() if self.session.nil?
    xml = RestClient.get(get_url("credentials.xml"), {"X-API-VERSION" => "1.0", :cookie => self.session})
    parser = XML::Parser.string(xml)
    doc = parser.parse
    creds = []
    doc.find('//credential').each do |c|
      creds << {"name" => c.find("name").first.content,
                "description" => c.find("description").first.content}
                #"value" => c.find("value").first.content}
    end
    creds
  end

  def get(action, headers={})
    login() if self.session.nil?
    #puts "Calling #{get_url(action)}"
    JSON.parse(RestClient.get(get_url(action), headers.merge(default_headers)))
  end

  def post(action, payload, headers={})
    login() if self.session.nil?
    RestClient.post(get_url(action), payload, headers.merge(default_headers))
  end

  def put(action, payload, headers={})
    login() if self.session.nil?
    RestClient.put(get_url(action), payload, headers.merge(default_headers))
  end

  def delete(action, headers={})
    login() if self.session.nil?
    #puts "Calling DELETE on #{get_url(action)}"
    RestClient.delete(get_url(action), headers.merge(default_headers))
  end

  def default_headers
    {"X-API-VERSION" => "1.0", :cookie => session}
  end

  def get_url(action)
    if action[0..3] == "http"
      action
    else
      "https://my.rightscale.com/api/acct/#{self.id}/#{action}"
    end
  end
end
