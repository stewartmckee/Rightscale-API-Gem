# To change this template, choose Tools | Templates
# and open the template in the editor.

class RightScript
  attr_accessor :name, :description, :href, :script, :updated_at, :created_at, :version, :inputs
  
  def initialize(name, description, script, created_at, updated_at)
    self.name = name
    self.description = description
    self.script = script
    self.created_at = created_at
    self.updated_at = updated_at
  end  
  
  def create(name, description, script, inputs, version)
    right_script = RightScript.new
    api = RightScaleApi.new

    post_params = {"right_script[name]" => name,
    "right_script[description]" => description,
    "right_script[script]" => script,
    "right_script[version]" => version}
    counter = 1
    inputs.each do |input|
      post_params << {"right_script[inputs][input#{counter}]", input}
      counter += 1
    end

    response = api.post("right_scripts", post_params)
    
    right_script.name = name
    right_script.description = description
    right_script.script = script
    right_script.inputs = inputs
    right_script.version = version
    right_script.href = response.headers[:location]
  end
  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    self.name = attribs["nickname"]
    self.description = attribs["description"]
    self.script = attribs["script"]
    self.created_at = attribs["created-at"]
    self.updated_at = attribs["updated-at"]
  end
  def save
    api = RightScaleApi.new
    put_params = {"right_script[name]" => name,
    "right_script[description]" => description,
    "right_script[script]" => script,
    "right_script[version]" => version}
    counter = 1
    inputs.each do |input|
      put_params << {"right_script[inputs][input#{counter}]", input}
      counter += 1
    end
    api.put(self.href, put_params)
  end
  def delete
    api = RightScaleApi.new
    api.delete(self.href)
  end
end
