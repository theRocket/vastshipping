require 'rails_helper'

RSpec.describe "ships/show", type: :view do
  before(:each) do
    @ship = assign(:ship, Ship.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
