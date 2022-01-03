import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  //
  LatLng indiaLocation = LatLng(20.5937, 78.9629);
  GoogleMapController? mapController;
  Marker? currentMarkr;
  Circle? circle;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        title: Text('Current Location'),

        //
        actions: [
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: () {
              getCurrentLocation();
            },
          ),
        ],
      ),

      //
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: indiaLocation,
          zoom: 10,
        ),

        //
        onMapCreated: (mapController) {
          this.mapController = mapController;
        },
        //
        markers: {if (currentMarkr != null) currentMarkr!},
        //
        circles: {if (circle != null) circle!},
        //
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    // check location service is enabled
    bool isServicedEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServicedEnabled) {
      print(' Device has no loction service');
      Geolocator.requestPermission();
    }
    // if location service is enable request to access the location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    Position currentPositon = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentPositon.latitude,
            currentPositon.longitude,
          ),
          zoom: 25,
        ),
      ),
    );
    currentMarkr = Marker(
      markerId: const MarkerId('my_location'),
      position: LatLng(currentPositon.latitude, currentPositon.longitude),
    );

    circle = Circle(
      circleId: CircleId('my_location'),
      center: LatLng(currentPositon.latitude, currentPositon.longitude),
      radius: 3,
      strokeColor: Colors.green.shade300,
      strokeWidth: 1,
      fillColor: Colors.green.shade200,
    );

    setState(() {
      //
    });
  }
}
