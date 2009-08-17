require 'rest_client'
require 'base64'
require 'json'
require 'xml'
require 'yaml'

class RightScaleApi
  RestClient.log = "tmp/restclient.log"
  attr_accessor :session, :id

  def login()
    config = YAML.load(File.open(File.dirname(__FILE__) + '/../config.yml'))
    self.id = config["credentials"]["id"]
    auth = "#{config["credentials"]["email"]}:#{config["credentials"]["password"]}"
    auth =  Base64.encode64(auth)
    response = RestClient.head(get_url("login"), {"X-API-VERSION" => "1.0", :Authorization => "Basic #{auth}"})
    self.session = response.headers[:set_cookie]
    self.session
  end

  def deployments
    get("deployments.js")
  end
  def servers
    get("servers.js")
  end
  def statuses
    get("statuses.js")
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
    get("deployments.js")
  end
  def ec2_security_groups
    get("ec2_security_groups.js")
  end
  def ec2_ssh_keys
    get("ec2_ssh_keys.js")
  end
  def server_arrays
    get("server_arrays.js")
  end
  def server_templates
    get("server_templates.js")
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
    puts "Calling #{get_url(action)}"
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
    puts "Calling DELETE on #{get_url(action)}"
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
