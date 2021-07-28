class Port < ApplicationRecord
    has_many :to_port_logs, class_name: "FleetTravelLogs",
             foreign_key: "to_port_id"
    has_many :from_port_logs, class_name: "FleetTravelLogs",
             foreign_key: "from_port_id"
end
