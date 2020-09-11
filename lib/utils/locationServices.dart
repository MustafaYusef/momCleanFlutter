import 'package:location/location.dart';
import 'package:mom_clean/utils/userLocation.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServices {
  UserLocation _currentLocation;

  var location = Location();
  var per = Permission.location;

  Future<UserLocation> getCurrentLocation() async {
    if (per.isDenied != null) {
      print("permission deny");
      await Permission.location.request();
    }
    try {
      var userLocation = await location.getLocation();
      _currentLocation =
          UserLocation(lat: userLocation.latitude, lon: userLocation.longitude);
    } catch (e) {
      print("could not get the location");
    }
    return _currentLocation;
  }
}
