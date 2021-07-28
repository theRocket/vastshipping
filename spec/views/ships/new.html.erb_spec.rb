require 'rails_helper'

RSpec.describe "ships/new", type: :view do
  before(:each) do
    assign(:ship, Ship.new())
  end

  it "renders new ship form" do
    render

    assert_select "form[action=?][method=?]", ships_path, "post" do
    end
  end
end
