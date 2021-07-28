require 'rails_helper'

RSpec.describe Ship, type: :model do
  subject { described_class.new }

  it "is valid with valid attributes" do
    subject.name = "Brand New Port"
    expect(subject).to be_valid

  end

  it "is not valid without a name" do
    ship = Ship.new(name: nil)
    expect(ship).to_not be_valid
  end
  
end
