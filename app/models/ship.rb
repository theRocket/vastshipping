class Ship < ApplicationRecord
    has_many :fleet_travel_logs, dependent: :destroy
end
