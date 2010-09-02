require File.dirname(__FILE__) + '/right_scale_api.rb'
require 'rest_client'
require 'json'

class Deployment
  attr_accessor :created_at, :description, :updated_at, :name, :href, :parameters
  
  def initialize(name, description, href, created_at, updated_at, servers_href)
    self.name = name
    self.description = description
    self.href = href
    self.updated_at = updated_at
    self.created_at = created_at
    
    @servers_href = servers_href
  end
  
  def servers
    api = RightScaleApi.new
    servers = []
    @servers_href.each do |server_href|
      
      server = api.get("#{server_href["href"]}.js")
      servers << Server.new(server["server_template_href"],server["href"],server["server_type"],server["created_at"],server["nickname"],server["updated_at"],server["tags"],server["deployment_href"],server["current_instance_href"],server["state"])
    end
    servers
  end

  def self.create(name, description)
    deployment = Deployment.new(name, description, nil, nil, nil)
    api = RightScaleApi.new
    response = api.post("deployments", {"deployment[nickname]" => name, "deployment[description]" => description})
    deployment.href = response.headers[:location]
    deployment
  end
  def self.from_href(href)
    deployment = Deployment.new(nil, nil, href, nil, nil)
    deployment.update
    deployment
  end
  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    self.created_at = attribs["created-at"]
    self.description = attribs["description"]
    self.name = attribs["nickname"]
    self.updated_at = attribs["updated-at"]
  end
  def save
    api = RightScaleApi.new
    api.put(self.href, {"deployment[nickname]" => self.name, "deployment[description]" => self.description})
    #"deployment[parameters]" => parameters}
  end
  def delete
    api = RightScaleApi.new
    api.delete(self.href)
  end
  
  def start_all
    api = RightScaleApi.new
    api.post(self.href + "/start_all")
  end
  def stop_all
    api = RightScaleApi.new
    api.post(self.href + "/stop_all")
  end
  def duplicate
    api = RightScaleApi.new
    api.post(self.href + "/duplicate")
  end
end
