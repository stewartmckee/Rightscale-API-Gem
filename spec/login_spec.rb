require File.dirname(__FILE__) + '/../lib/login.rb'

describe Login do
  before(:each) do
    
  end

  it "should successfully login" do
    Login.new("11415", "stewart.mckee@vamosa.com", "Asomav1")
  end
end

