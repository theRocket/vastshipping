require 'rails_helper'

RSpec.describe FleetTravelLog, type: :model do

  ship = Ship.new(:name => "Big Boat")
  port1 = Port.new(:name => "From Port")
  port2 = Port.new(:name => "To Port")
  subject {
    described_class.new(ship: ship,
                        from_port: port1,
                        to_port: port2,
                        time_depart: DateTime.now,
                        time_arrive: DateTime.now + 1.day
                      )
  }
  describe "Associations" do
    it { should belong_to(:ship).without_validating_presence }
  end
  describe "Associations" do
    it { should belong_to(:to_port).without_validating_presence }
  end
  describe "Associations" do
    it { should belong_to(:from_port).without_validating_presence }
  end
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a time_depart" do
    subject.time_depart = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a time_arrive" do
    subject.time_arrive = nil
    expect(subject).to_not be_valid
  end
end
