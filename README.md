# Vast Shipping Company

## Requirements Added

- Docker Desktop running (for `docker-compose` commands)
- ports 3001 and 3307 open on the host (for Puma and MySQL, respectively)

### Requirements Complied With

- __Did not post this challenge or my solution on any public website__ -- (used private Github Repo)
- Wrote unit tests in RSpec
- Used rubocop for code style enforcement

### Starting App

1. From project root directory:

> docker-compose up -d

If container fails to start due to a missing ruby dependency (like `mini_portile2 2.5.3`), the Docker image build may have missed it during `bundle install`. Exec into the container with:
> docker-compose run --rm --service-ports app bash

> bundle install

> exit

Then repeat Step 1, since your Rails container stopped upon exit of the bash session.

2. Once both containers are running, you'll have to exec into the Rails container again to talk to the MySQL database:

> docker exec -it sportradar_vastshipping_app_1 /bin/sh

> bundle exec rake db:migrate

> bundle exec rake db:seed

This will create the table schemas and populate the data from the CSV files provided, with relations built in. Example, from the Rails console (note the internal IDs are shifted by one to accomodate MySQL autoincrement behavior for primary keys):

> ./bin/rails c

>irb(main):001:0> s = Ship.find(1)
  Ship Load (0.8ms)  SELECT `ships`.* FROM `ships` WHERE `ships`.`id` = 1 LIMIT 1
=> #<Ship id: 1, name: "Alpha", created_at: "2021-07-28 02:58:10", updated_at: "2021-07-28 02:58:10">

>irb(main):002:0> s.fleet_travel_logs
  FleetTravelLog Load (0.5ms)  SELECT `fleet_travel_logs`.* FROM `fleet_travel_logs` WHERE `fleet_travel_logs`.`ship_id` = 1 LIMIT 11
  => #<ActiveRecord::Associations::CollectionProxy [#<FleetTravelLog id: 4, ship_id: 1, from_port_id: 8, to_port_id: 4, time_depart: "2016-06-12 11:20:00", time_arrive: "2016-06-12 13:05:36", distance_traveled: 81.0, average_trip_speed: 46.0227>, #<FleetTravelLog id: 7, ship_id: 1, from_port_id: 4, to_port_id: 7, time_depart: "2016-06-12 15:14:36", time_arrive: "2016-06-12 16:29:00" ...

> irb(main):003:0> s.fleet_travel_logs.count()
   (0.7ms)  SELECT COUNT(*) FROM `fleet_travel_logs` WHERE `fleet_travel_logs`.`ship_id` = 1
=> 74

Note the times were converted from `-0500` (GMT-5) in the text file to UTC in the database:

> irb(main):010:0> log = s.fleet_travel_logs.first.time_depart.zone
=> "UTC"

So converting it back to CDT for Minneapolis, MN at runtime is necessary to make the "same day" calculations accurate. This is done by setting the Rails environment in `config/application.rb`:

> irb(main):001:0> Time.zone
=> #<ActiveSupport::TimeZone:0x000055cb3565ee28 @name="Central Time (US & Canada)", @utc_offset=nil, @tzinfo=#<TZInfo::DataTimezone: America/Chicago>>

3. Go to [localhost:3001](http://localhost:3001) to see the Fleet Manager dashboard.

## Running Tests
Several steps involved here, beginning with creating the test database and with stopping and starting the Rails container into test mode (this could be automated for CI/CD workflows):
> docker exec -it sportradar_vastshipping_mysql_1 /bin/sh

> mysql -u root -p

> create database app_test;

> exit


> docker-compose run --rm --service-ports -e RAILS_ENV=test app bash

> root@08d697da21cb:/home/app# echo $RAILS_ENV
test

> ./bin/rails generate rspec:install

> bundle exec rake db:migrate

> bundle exec rspec spec/models

## Sport Radar Contact

My contact has been Sean Quinn (s.quinn@sportradar.com) and I have shared this private repo on Github only with him.

## Background Provided

The Vast Shipping Company has a fleet of ships that venture between a set of sea ports in the Wohlstand Sea. The ships and their crews work non stop to load and deliver goods to ports. While the crews diligently work to deliver goods the owner of the Vast Shipping Company likes to track certain statistics of his fleet to help him optimize the business.

## Programming Challenge

Develop a class called FleetManager that would have the following methods or properties. Note, the definition of a 'completed trip' is a trip that has both started and ended. So when we are interested in number of completed trips in a day, we are interested in the trips that both started and completed with in that day. For this challenge, assume that the owner of Vast Shipping and all the boats operate in the same timezone.


```ruby
manager = FleetManager.new

# Returns a collection of all the ships in the fleet (see FleetShip class)
manager.ships

# Returns the ship (instance of FleetShip) with the slowest trip out of all the completed trips by all ships that day
manager.slowest_ship(time)

# Returns the ship (instance of FleetShip) with the fastest trip out of all the completed trips by all ships that day
manager.fastest_ship(time)

# Returns the name of the port most visited out of all the ports which were visited by the ships in that day.
# Do not count the first port that the ship left as a visited port.
manager.most_visited_port(time)

# Returns the name of the port least visited out of all the ports which were visited by the ships in that day,
# Do not count the first port that the ship left as a visited port.
manager.least_visited_port(time)

```

Develop a class called FleetShip that would have the following methods or properties

```ruby
# Returns the name of the ship
ship.name


# Returns a float representing the number of kilometers traveled with the completed trips on that day.
ship.distance_traveled(time)

# Returns a hash representing the completed trip of that day with the fastest average speed (distance in km/time in hr).
# The hash returned includes the name of the beginning port, the name of ending port, depart_time, arrival_time, number 
# of kilometers between the ports, and the average speed in kilometers for the completed. If there is more than one trip
# with the same fastest average speed, only return the first one. 
ship.fastest_trip(time)

# Returns a hash representing the completed trip of that day with the slowest average speed (distance in km/time in hr).
# The hash returned includes the name of the beginning port, the name of ending port, depart_time, arrival_time, number
# of kilometers between the ports, and the average speed in kilometers for the completed. If there is more than one trip
# with the same slowest average speed, only return the last one. 
ship.slowest_trip(time)

```

### Data Files

There are four data files:
 - distances.txt
 - fleet_travel_log.txt
 - ports.txt
 - ships.txt
 
Read in and parse these files, i.e., do not hard code any of these values.
 
#### ports.txt and ships.txt
These two files contain the names of the ports and the names of the ships. Their ids are based on zero-based row
position. So for example the port 'Havennesse' has the id of zero. These ids are used in the other files.

#### distances.txt
This table represents the distances in kilometers between the ports in the Wohlstand sea. So for example if we want the 
distance between ports 0 and 3, then we would look at position [0,3], which in this case would be 59.

#### fleet_travel_log.txt
This is a log that contains a snapshot of the travels of the ships. The columns of this table are as follows: ship id,
beginning port id, ending port id, time left, time arrived. 
 
## The data_file_helpers.rb file
This file has been included as a file you may to incorporate/import it into your solution. Totally up to you.

