class PagesController < ApplicationController
    def dashboard
        # all tables
        @ports = Port.all
        @ships = Ship.all
        @fleet_logs = FleetTravelLog.order(:time_depart)

        # Fleet Manager
        # get unique days in the logs
        @dates = @fleet_logs.pluck(:time_depart).map {|a| a.strftime("%d-%m-%Y")}.uniq # [a.strftime("%m-%d-%Y"), a.to_date]
        # get stats if query submitted (otherwise send nil)
        # Ships
        log_slow = FleetTravelLog.query_slowest(params[:sail_day])
        @ship_slow = (log_slow) ? log_slow.ship : nil
        log_fast = FleetTravelLog.query_fastest(params[:sail_day])
        @ship_fast = (log_fast) ? log_fast.ship : nil
        # Ports
        @port_most = Port.query_visits(params[:sail_day],'most')
        @port_least = Port.query_visits(params[:sail_day],'least')
    end
    
  end