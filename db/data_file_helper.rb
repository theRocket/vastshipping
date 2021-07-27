# frozen_string_literal: true

require 'csv'
require 'time'

# helper methods and constants for the travel logs
module DataFileHelper
  DATA_DIR = File.join(__dir__, 'data').freeze

  # 0, 7, 3, 2016-06-12 06:20:00 -0500, 2016-06-12 08:05:36 -0500
  SHIP_ID_COLUMN = 0
  BEGIN_PORT_COLUMN = 1
  END_PORT_COLUMN = 2
  DEPART_TIME_COLUMN = 3
  ARRIVAL_TIME_COLUMN = 4
  DISTANCE_TRAVELED_COLUMN = 5 # Added after load, in km
  AVERAGE_TRIP_SPEED_COLUMN = 6 # Added after load, in km/hr

  CSV::Converters[:log_date_times] = lambda { |s|
    Time.parse(s) if /\d{4}-\d{2}-\d{2}/.match?(s)
  }

  private

  def load_data_files
    @distances_data = CSV.parse(
      open_data_file('distances.txt'),
      converters: [CSV::Converters[:float]]
    )
    @ports_data = File.readlines(open_data_file('ports.txt')).map(&:strip)
    @ships_data = File.readlines(open_data_file('ships.txt')).map(&:strip)
    @fleet_travel_log = load_travel_log(File.join(DATA_DIR, 'fleet_travel_log.txt'), @distances_data)
  end

  # adds a new column per entry of the average trip speed
  def add_distance_and_average_speeds(travel_log, distances)
    travel_log.each do |entry|
      # distance / (end_time - beginning_time)
      distance = distances[entry[BEGIN_PORT_COLUMN]][entry[END_PORT_COLUMN]]
      entry[DISTANCE_TRAVELED_COLUMN] = distance
      entry[AVERAGE_TRIP_SPEED_COLUMN] = distance / ((entry[ARRIVAL_TIME_COLUMN] - entry[DEPART_TIME_COLUMN]) / 3600)
    end
  end

  def load_travel_log(full_file_path, distances)
    travel_log = CSV.parse(
      File.open(full_file_path),
      converters: [CSV::Converters[:integer], CSV::Converters[:log_date_times]]
    )

    add_distance_and_average_speeds(travel_log, distances)

    travel_log
  end

  def day_log(travel_log, time)
    day = safe_date_parse(time)
    travel_log.find_all do |entry|
      entry[DEPART_TIME_COLUMN].to_date == day && entry[ARRIVAL_TIME_COLUMN].to_date == day
    end
  end

  def safe_date_parse(time)
    time.is_a?(Time) ? time.to_date : Time.parse(time.to_s).to_date
  end

  def open_data_file(datafile_name)
    File.open(File.join(DATA_DIR, datafile_name))
  end
end
