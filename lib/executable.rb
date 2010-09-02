class Executable
  attr_accessor :position, :apply, :recipe, :right_script
  
  @rightscale_api = nil  
  
  def initialize(position, apply, recipe, right_script_href)
    @rightscale_api = RightScaleApi.new if @rightscale_api.nil?
    self.position = position
    self.apply = apply
    self.recipe = recipe
    doc = @rightscale_api.get(right_script_href)
    s = doc.find('//right-script').first
    self.right_script = RightScript.new(s.find("name").first.content,s.find("description").first.content,s.find("script").first.content,s.find("created-at").first.content,s.find("updated-at").first.content)
  end
  
  def to_s
    ap self.right_script
  end
  

end