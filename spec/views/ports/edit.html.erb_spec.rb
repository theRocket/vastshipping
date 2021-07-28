require 'rails_helper'

RSpec.describe "ports/edit", type: :view do
  before(:each) do
    @port = assign(:port, Port.create!())
  end

  it "renders the edit port form" do
    render

    assert_select "form[action=?][method=?]", port_path(@port), "post" do
    end
  end
end
