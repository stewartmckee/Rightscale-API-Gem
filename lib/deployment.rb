require File.dirname(__FILE__) + '/right_scale_api.rb'
require 'rest_client'
require 'json'

class Deployment
  attr_accessor :created_at, :description, :updated_at, :nickname, :href, :servers, :parameters
  
  def self.create(nickname, description)
    deployment = Deployment.new
    api = RightScaleApi.new
    response = api.post("deployments", {"deployment[nickname]" => nickname, "deployment[description]" => description})
    deployment.nickname = nickname
    deployment.description = description
    deployment.href = response.headers[:location]
    deployment
  end
  def self.from_href(href)
    deployment = Deployment.new
    deployment.href = href
    deployment.update
    deployment
  end
  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    self.created_at = attribs["created-at"]
    self.description = attribs["description"]
    self.nickname = attribs["nickname"]
    self.updated_at = attribs["updated-at"]
  end
  def save
    api = RightScaleApi.new
    api.put(self.href, {"deployment[nickname]" => self.nickname, "deployment[description]" => self.description})
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
