class FleetTravelLog < ApplicationRecord
    belongs_to :ship
    belongs_to :from_port, class_name: "Port"
    belongs_to :to_port, class_name: "Port"

    def self.query_slowest(sail_day)
        if sail_day
            # query in local time zone to ensure same day as User
            sail_date = sail_day.in_time_zone(Time.zone)
            FleetTravelLog
                .where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
                .order(:average_trip_speed).first
        end
    end

    def self.query_fastest(sail_day)
        if sail_day
            # query in local time zone to ensure same day as User
            sail_date = sail_day.in_time_zone(Time.zone)
            FleetTravelLog
                .where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
                .order(:average_trip_speed).last
        end
    end

end
