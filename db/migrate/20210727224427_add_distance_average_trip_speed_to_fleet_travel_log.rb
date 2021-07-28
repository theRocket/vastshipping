class AddDistanceAverageTripSpeedToFleetTravelLog < ActiveRecord::Migration[6.0]
  def change
    add_column :fleet_travel_logs, :distance_traveled, :float
    add_column :fleet_travel_logs, :average_trip_speed, :float
  end
end
