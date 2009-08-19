require File.dirname(__FILE__) + '/aws_permission.rb'

class EC2SecurityGroup
  attr_accessor :aws_description, :aws_group_name, :aws_perms, :href

  def initialize(aws_description, aws_group_name, aws_perms)
    self.aws_description = aws_description
    self.aws_group_name = aws_group_name
    #self.href = href
    self.aws_perms = []
    aws_perms.each do |perm|
      self.aws_perms << AwsPermission.new(perm)
    end
  end

  #def self.from_href(href)
  #  group = EC2SecurityGroup.new
  #  group.href = href
  #  group.update
  #  group
  #end

  #def update
  #  api = RightScaleApi.new
  #  attribs = api.get(self.href + ".js")
  #  self.aws_description = attribs["aws_description"]
  #  self.aws_group_name = attribs["aws_group_name"]
  #  self.aws_perms = []
  #  attribs["aws_perms"].each do |perm|
  #    self.aws_perms << AwsPermission.new(perm)
  #  end
  #end
end
