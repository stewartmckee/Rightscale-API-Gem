# To change this template, choose Tools | Templates
# and open the template in the editor.

class Server
  attr_accessor :created_at, :updated_at, :name, :href, :state, :server_type, :server_template, :ec2_ssh_key, :ec2_security_groups, :aki_image, :ari_image, :ec2_image, :instance_type

  @rightscale_api = nil

  def initialize(server_template_href,href,server_type,created_at,nickname,updated_at,tags,deployment_href,current_instance_href,state)
    self.href = href
    self.server_type = server_type
    self.created_at = created_at
    self.name = nickname
    self.updated_at = updated_at
    self.state = state

    @deployment_href = deployment_href 
    @server_template_href = server_template_href
    @current_instance_href = current_instance_href
  end
  
  def deployment
    @rightscale_api = RightScaleApi.new if @rightscale_api.nil?
    d = @rightscale_api.get("#{@deployment_href}.js")
    Deployment.new(d["nickname"], d["description"], d["href"], d["created_at"], d["updated_at"], d["servers"])
  end
  
  def template
    @rightscale_api = RightScaleApi.new if @rightscale_api.nil?
    template = @rightscale_api.get("#{@server_template_href}.js")
    ServerTemplate.new(template["nickname"],template["description"],template["href"],template["updated_at"])
  end  
  def instance
    @rightscale_api = RightScaleApi.new if @rightscale_api.nil?
    instance = @rightscale_api.get("#{@current_instance_href}.js")
    ap instance
    #Deployment.new(d["nickname"], d["description"], d["href"], d["created_at"], d["updated_at"])  
  end

  def self.create(name, server_template, ec2_ssh_key, ec2_security_group, deployment, aki_image, ari_image, ec2_image, instance_type)
    server = Server.new
    api = RightScaleApi.new
    response = api.post("servers", {"server[nickname]" => self.name,
                                    "server[server_template_href]" => server_template.href,
                                    "server[ec2_ssh_key_href]" => ec2_ssh_key.href,
                                    "server[ec2_security_group_href]" => ec2_security_group.href,
                                    "server[deployment_href]" => deployment.href,
                                    "server[aki_image_href]" => aki_image.href,
                                    "server[ari_image_href]" => ari_image.href,
                                    "server[ec2_image_href]" => ec2_image.href,
                                    "server[instance_type]" => instance_type})

    server.name = name
    server.server_template = server_template
    server.ec2_ssh_key = ec2_ssh_key
    server.ec2_security_group = ec2_security_group
    server.deployment = deployment
    server.aki_image = aki_image
    server.ari_image = ari_image
    server.ec2_image = ec2_image
    server.instance_type = instance_type
    
    server.href = response.headers[:location]
  end
  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    
    self.name = attribs["nickname"]
    self.deployment = Deployment.from_href(attribs["deployment-href"])
    self.server_type = attribs["server-type"]
    self.state = attribs["state"]
    self.created_at = attribs["created-at"]
    self.updated_at = attribs["updated-at"]

    settings = api.get(self.href + "/settings.js")

    self.ec2_ssh_key = Ec2-ssh-key.from_href(settings["ec2-ssh-key"])
    self.ec2_security_groups = []
    settings["ec2-security-groups"].each do |group|
      self.ec2_security_groups << Ec2-security-group.from_href(group["ec2-security-group-href"])
    end
    self.ec2_instance_type = settings["ec2-instance-type"]
    self.aki_image = Aki_image.from_href(settings["aki-image-href"])
    self.ari_image = Ari_image.from_href(settings["ari-image-href"])
    self.ec2_image = Ec2_image.from_href(settings["ec2-image-href"])
    self.aws_platform = settings["aws-platform"]
    self.dns_name = settings["dns-name"]
    self.private_dns_name = settings["private-dns-name"]
    self.aws_id = settings["aws-id"]
    self.cloud_id = settings["cloud-id"]
    self.aws_product_codes = settings["aws-product-codes"]
  end
  def save
    api = RightScaleApi.new
    api.put(self.href, {"server[nickname]" => self.name, "server[description]" => self.description})
    #"server[parameters]" => parameters}
  end
  def delete
    api = RightScaleApi.new
    api.delete(self.href)
  end

  def start
    api = RightScaleApi.new
    api.post(self.href + "/start")
  end
  def stop
    api = RightScaleApi.new
    api.post(self.href + "/stop")
  end
  def reboot
    api = RightScaleApi.new
    api.post(self.href + "/reboot")
  end
  def run_script(right_script)
    api = RightScaleApi.new
    response = api.post(self.href + "/run_script", {"right_script" => right_script.id})
    status = Status.from_href(response.headers[:location])
    status
  end
end
