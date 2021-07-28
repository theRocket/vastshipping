require 'rails_helper'

RSpec.describe "ships/index", type: :view do
  before(:each) do
    assign(:ships, [
      Ship.create!(),
      Ship.create!()
    ])
  end

  it "renders a list of ships" do
    render
  end
end
