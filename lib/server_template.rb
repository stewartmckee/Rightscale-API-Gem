# To change this template, choose Tools | Templates
# and open the template in the editor.

class ServerTemplate
  attr_accessor :updated_at, :name, :description, :href, :aki_image, :ari_image, :ec2_image, :instance_type, :ec2_user_data
  
  def create(name, description, aki_image, ari_image, ec2_image, instance_type, ec2_user_data)
    server_template = ServerTemplate.new
    api = RightScaleApi.new
    response = api.post("server_templates", {"server_template[nickname]" => name,
    "server_template[description]" => description,
    "server_template[ec2_image_href]" => ec2_image.href,
    "server_template[aki_image_href]" => aki_image.href,
    "server_template[ari_image_href]" => ari_image.href,
    "server_template[instance_type]" => instance_type,
    "server_template[ec2_user_data]" => ec2_user_data})
    
    server_template.name = name
    server_template.description = description
    server_template.ec2_image = ec2_image
    server_template.aki_image = aki_image
    server_template.ari_image = ari_image
    server_template.instance_type = instance_type
    server_template.ec2_user_data
    server_template.href = response.headers[:location]
  end
  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    self.name = attribs["nickname"]
    self.description = attribs["description"]
    self.updated_at = attribs["updated-at"]
  end
  def save
    api = RightScaleApi.new
    api.put(self.href, {"server_template[nickname]" => self.name, "server_template[description]" => self.description})
    #"server_template[parameters]" => parameters}
  end
  def delete
    api = RightScaleApi.new
    api.delete(self.href)
  end
end
