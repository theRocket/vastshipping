# Vast Shipping Company

## Requirements Added

- Docker Desktop running (for `docker-compose` commands)
- ports 3000 and 3307 open on the host (for Puma and MySQL, respectively)

### Requirements Complied With

- __Did not post this challenge or my solution on any public website__ -- (used private Github Repo)
- Wrote unit tests in RSpec
- Used rubocop for code style enforcement

### Starting App

1. From project root directory:

> docker-compose up

If container fails to start due to a missing ruby dependency, the Docker build may have missed it during `bundle install`. Exec into the container with:
> docker-compose run --rm --service-ports app bash
> bundle install
> exit

Then repeat Step 1, since your Rails container stopped upon exit of the bash session.

2. Once both containers are running, you'll have to exec into the Rails container again to talk to the MySQL database

> ~ docker exec -it sportradar_vastshipping_app_1 /bin/sh
> bundle exec rake db:migrate
> bundle exec rake db:seed

This will create the tables and populate the data from the CSV files provided

## Sport Radar Contact

My contact has been Sean Quinn (s.quinn@sportradar.com) and I have shared this private repo on Github only with him.

## Background Provided

The Vast Shipping Company has a fleet of ships that venture between a set of sea ports in the Wohlstand Sea. The ships
and their crews work non stop to load and deliver goods to ports. While the crews diligently work to deliver goods
the owner of the Vast Shipping Company likes to track certain statistics of his fleet to help him optimize the
business.

## Programming Challenge

Develop a class called FleetManager that would have the following methods or properties. Note, the definition of a
'completed trip' is a trip that has both started and ended. So when we are interested in number of completed trips
in a day, we are interested in the trips that both started and completed with in that day. For this challenge, assume
that the owner of Vast Shipping and all the boats operate in the same timezone.


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

