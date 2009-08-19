# To change this template, choose Tools | Templates
# and open the template in the editor.

class AwsPermission

  attr_accessor :owner, :group, :protocol, :cidr_ips, :from_port, :to_port

  def initialize(hash)
    if hash["owner"].nil?
      self.protocol = hash["protocol"]
      self.cidr_ips = hash["cidr_ips"]
      self.from_port = hash["from_port"]
      self.to_port = hash["to_port"]
    else
      self.owner = hash["owner"]
      self.group = hash["group"]
    end
  end
end
