class Port < ApplicationRecord
    has_many :to_port_logs, class_name: "FleetTravelLog",
             foreign_key: "to_port_id"
    has_many :from_port_logs, class_name: "FleetTravelLog",
             foreign_key: "from_port_id"

    validates_presence_of :name

    def self.query_visits(sail_date, which)
        # gets a hash of key: Port ID, value: count
        log_join = FleetTravelLog.joins(:to_port)
                .where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
                .group("fleet_travel_logs.to_port_id")
                .count()

        if log_join
            # sort ascending returns array
            port_ids = log_join.sort_by {|k, v| v}
            case which
            when 'most'
                Port.find(port_ids.last[0]) # highest count, grab key
            else # presumed 'least'
                Port.find(port_ids.first[0]) # lowest count, grab key
            end
        end
    end
end