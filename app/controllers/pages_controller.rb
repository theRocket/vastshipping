class PagesController < ApplicationController
    def dashboard
        # all tables
        @ports = Port.all
        @ships = Ship.all
        @fleet_logs = FleetTravelLog.order(:time_depart)

        # Fleet Manager
        # get unique days in the logs
        @dates = @fleet_logs.pluck(:time_depart).map {|a| a.to_date}.uniq # [a.strftime("%m-%d-%Y"), a.to_date]
        # echo selected date back to get stats if query submitted (otherwise send nil)
        if(params[:sail_day])
            # query in local time zone to ensure same day as User
            sail_date = params[:sail_day].in_time_zone(Time.zone)
            # Get Ships
            log_slow = FleetTravelLog.query_slowest(sail_date)
            @ship_slow = (log_slow) ? log_slow.ship : nil
            log_fast = FleetTravelLog.query_fastest(sail_date)
            @ship_fast = (log_fast) ? log_fast.ship : nil
            # Get Ports
            @port_most = Port.query_visits(sail_date,'most')
            @port_least = Port.query_visits(sail_date,'least')

            ship_dist_hash = Ship.distance_traveled(sail_date)
            # e.g. {1=>321.0, 2=>132.0, 3=>231.0}
            # Get Fastest Trips for each Ship
            @fastest_trips = []
            @trip_distances = []
            @ships.each do |ship|
                # build array of ship name and distances
                ship_dist = ship_dist_hash[ship.id]
                @trip_distances.append([ship.name, (ship_dist ? ship_dist : 0)])
                @fastest_trips.append(
                    ship.fleet_travel_logs.where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
                        .order(:average_trip_speed)
                        .last
                )
            end
            # resize for days with fewer ships
            @trip_distances.reject! { |x| x.nil? } 
            @fastest_trips.reject! { |x| x.nil? } 

            # Get Slowest Trips for each Ship
            @slowest_trips = []
            @ships.each do |ship|
                @slowest_trips.append(
                    ship.fleet_travel_logs.where('time_depart >= ? AND time_arrive < ?', sail_date, sail_date+1.day)
                        .order(:average_trip_speed)
                        .first
                )
            end
            @slowest_trips.reject! { |x| x.nil? } # effectively a resize
        end
    end
    
  end