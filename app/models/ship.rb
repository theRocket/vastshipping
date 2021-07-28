class Ship < ApplicationRecord
    has_many :fleet_travel_logs, dependent: :destroy

    validates_presence_of :name

    def self.distance_traveled(sail_date)    
        # returns a hash of key: Ship ID, value: sum distances traveled on day
        Ship.joins(:fleet_travel_logs)
                .where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
                .group("fleet_travel_logs.ship_id")
                .sum(:distance_traveled)
    end
    
end