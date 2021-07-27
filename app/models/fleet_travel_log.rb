class FleetTravelLog < ApplicationRecord
    belongs_to :ship
    belongs_to :from_port, class_name: "Port"
    belongs_to :to_port, class_name: "Port"
end
