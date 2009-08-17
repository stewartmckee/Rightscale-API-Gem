# To change this template, choose Tools | Templates
# and open the template in the editor.

class Status
  attr_accessor :started_at, :ended_at, :href, :state, :description

  def self.from_href(href)
    status = Status.new
    status.href = href
    status.update
    status
  end

  def update
    api = RightScaleApi.new
    attribs = api.get(self.href + ".js")
    
    self.description = attribs["description"]
    self.state = attribs["state"]
    self.started_at = attribs["created-at"]
    self.ended_at = attribs["updated-at"]
  end
end
