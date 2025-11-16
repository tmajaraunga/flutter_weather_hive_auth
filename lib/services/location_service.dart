import 'package:location/location.dart';


class LocationService {
  final Location _location = Location();


  Future<bool> requestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _location.requestService();
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted && serviceEnabled;
  }


  Future<LocationData> getLocation() async {
    final ok = await requestPermission();
    if (!ok) throw Exception('Location permission not granted');
    return await _location.getLocation();
  }


  Stream<LocationData> onLocationChanged() => _location.onLocationChanged;
}