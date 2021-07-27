class CreateFleetTravelLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :fleet_travel_logs do |t|
      t.references :ship, index: true, foreign_key: true
      t.integer :from_port, foreign_key: true
      t.integer :to_port, foreign_key: true
      t.datetime :time_depart
      t.datetime :time_arrive

      t.timestamps
    end
  end
end
