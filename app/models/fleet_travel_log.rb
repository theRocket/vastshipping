class FleetTravelLog < ApplicationRecord
    belongs_to :ship
    belongs_to :from_port, class_name: "Port"
    belongs_to :to_port, class_name: "Port"

    validates_presence_of :ship
    validates_presence_of :from_port
    validates_presence_of :to_port
    validates_presence_of :time_depart
    validates_presence_of :time_arrive

    def self.query_slowest(sail_date)
        FleetTravelLog
            .where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
            .order(:average_trip_speed).first
    end

    def self.query_fastest(sail_date)
        FleetTravelLog
            .where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
            .order(:average_trip_speed).last
    end
end
