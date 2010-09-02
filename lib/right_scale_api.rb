require 'rest_client'
require 'base64'
require 'json'
require 'xml'
require 'yaml'
require 'digest/md5'


require File.dirname(__FILE__) + '/deployment.rb'
require File.dirname(__FILE__) + '/server.rb'
require File.dirname(__FILE__) + '/server_template.rb'
require File.dirname(__FILE__) + '/ec2_security_group.rb'
require File.dirname(__FILE__) + '/executable.rb'
require File.dirname(__FILE__) + '/right_script.rb'

class RightScaleApi
  RestClient.log = "tmp/restclient.log"
  
  @@session = nil
  
  def initialize()
    @config = YAML.load(File.open(File.dirname(__FILE__) + '/../config.yml'))
    @@id = @config["credentials"]["id"]
  end

  def login()
    auth = "#{@config["credentials"]["email"]}:#{@config["credentials"]["password"]}"
    auth =  Base64.encode64(auth)
    response = RestClient.head(get_url("login"), {"X-API-VERSION" => "1.0", :Authorization => "Basic #{auth}"})
    @@session = response.headers[:set_cookie]
    @@session
  end

  def deployments
    deployments = []
    get("deployments.js").each do |d|
      deployments << Deployment.new(d["nickname"], d["description"], d["href"], d["created_at"], d["updated_at"], d["servers"])
    end
    deployments
  end
  def servers
    servers = []
    get("servers.js").each do |server|
      servers << Server.new(server["server_template_href"],server["href"],server["server_type"],server["created_at"],server["nickname"],server["updated_at"],server["tags"],server["deployment_href"],server["current_instance_href"],server["state"])
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
    login() if @@session.nil?
    xml = RestClient.get(get_url("right_scripts.xml"), {"X-API-VERSION" => "1.0", :cookie => @@session})
    parser = XML::Parser.string(xml)
    doc = parser.parse
    scripts = []
    doc.find('//right-script').each do |s|
      scripts << RightScript.new(s.find("name").first.content,s.find("description").first.content,s.find("script").first.content,s.find("created-at").first.content,s.find("updated-at").first.content)
    end
    scripts
  end
  def macros
    get("macros.js")
  end
  def credentials
    login() if @@session.nil?
    xml = RestClient.get(get_url("credentials.xml"), {"X-API-VERSION" => "1.0", :cookie => @@session})
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
    login() if @@session.nil?

    url = get_url(action)
    cached_file = "cache/#{Digest::MD5.hexdigest(url)}"
    
    response = nil
    if File.exist?(cached_file)
      response = File.open(cached_file).readlines.join
    else
      response = RestClient.get(url, headers.merge(default_headers))
      write(cached_file, response)
    end
    
    result = nil
    if response.start_with?("<?xml")
      parser = XML::Parser.string(response)
      result = parser.parse
    else
      result = JSON.parse(response)
    end
    return {} if result.nil?
    result
  end

  def post(action, payload, headers={})
    login() if @@session.nil?
    RestClient.post(get_url(action), payload, headers.merge(default_headers))
  end

  def put(action, payload, headers={})
    login() if @@session.nil?
    RestClient.put(get_url(action), payload, headers.merge(default_headers))
  end

  def delete(action, headers={})
    login() if @@session.nil?
    #puts "Calling DELETE on #{get_url(action)}"
    RestClient.delete(get_url(action), headers.merge(default_headers))
  end

  def default_headers
    {"X-API-VERSION" => "1.0", :cookie => @@session}
  end

  def get_url(action)
    if action[0..3] == "http"
      action
    else
      "https://my.rightscale.com/api/acct/#{@@id}/#{action}"
    end
  end
  
  def write(filename, data)
    File.open(filename, "w") do |f|
      f.write(data)
    end
  end
end
