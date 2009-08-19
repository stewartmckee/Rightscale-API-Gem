# To change this template, choose Tools | Templates
# and open the template in the editor.

class EC2SSHKey
  attr_accessor :aws_key_name, :created_at, :updated_at, :href, :aws_fingerprint, :aws_material
  
  def self.from_href(href)
    key = EC2SSHKey.new
    key.href = href
    key.update
    key
  end
  def self.from_id(key_id)
    api = RightScaleApi.new
    EC2SSHKey.from_href(api.get_url("ec2_ssh_keys/#{key_id}"))
  end

  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    self.aws_key_name = attribs["aws_key_name"]
    self.aws_fingerprint = attribs["aws_fingerprint"]
    self.aws_material = attribs["aws_material"]
    self.created_at = attribs["created_at"]
    self.updated_at = attribs["updated_at"]
  end
end
