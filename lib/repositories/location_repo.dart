import 'package:flutter_app/models/location.dart';

class LocationRepository {
  List<Location> locations = [];

  void addLocation(String name) {
    locations.add(Location(name: name));
  }

  List<Location> getLocations() {
    return locations;
  }
}