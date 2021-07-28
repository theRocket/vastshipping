# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
require Rails.root.join('db','data_file_helper.rb')

include DataFileHelper

load_data_files
# loads data into global vars
# @ports_data
# @ships_data
# @fleet_travel_log

# presumes database starting from scratch with ID=1 for first record
# only run once or reset autoincrement point
# @ships_data.each do |row|
#   Ship.create({
#     name: row
#   }) 
#   end

# # presumes database starting from scratch with ID=1 for first record
# # only run once or reset autoincrement point
# @ports_data.each do |row|
#   Port.create( {
#     name: row
#   }) 
#   end

@fleet_travel_log.each do |item|
  # all IDs in data files are 0 based, but with assumptions above, need foreign key to be 1-based
  # TODO: could get the database autoincrement value first to make sure?
  offset = 1
  @ship = Ship.find(item[0]+offset)
  @port_from = Port.find(item[1]+offset)
  @port_to = Port.find(item[2]+offset)
  if (@ship && @port_from && @port_to)
    @ship.fleet_travel_logs.create( {
      from_port_id: @port_from.id,
      to_port_id: @port_to.id,
      time_depart: item[3],
      time_arrive: item[4],
      distance_traveled: item[5],
      average_trip_speed: item[6],
    })
    end

  # may be non-normalized, but we have the table already, so let's drop these in
  # Distance.create({
  #   from_port: @port_from.id,
  #   to_port: @port_to.id,
  #   kilometers: item[5]
  # })
  end