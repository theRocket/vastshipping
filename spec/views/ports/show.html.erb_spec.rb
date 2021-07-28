require 'rails_helper'

RSpec.describe "ports/show", type: :view do
  before(:each) do
    @port = assign(:port, Port.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
