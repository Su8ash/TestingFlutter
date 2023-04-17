import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocator extends StatefulWidget {
  const GeoLocator({super.key});

  @override
  State<GeoLocator> createState() => _GeoLocatorState();
}

class _GeoLocatorState extends State<GeoLocator> {
  Position? _position;
  List _stream = [];

  void getCurrentLocation() async {
    Position _currentPosition = await _determinePosition();
    setState(() {
      _position = _currentPosition;
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        // desiredAccuracy: LocationAccuracy.high,
        );
  }

  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ),
  ).listen((Position? position) {
    // if (position != null) {
    //   setState(() {
    //     _stream.add();
    //   });
    // }
    log(
      position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}',
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                getCurrentLocation();
              },
              icon: Icon(
                Icons.location_off,
              )),
          IconButton(
              onPressed: () {
                positionStream;
              },
              icon: Icon(
                Icons.location_on,
              ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(_position != null ? _position!.toString() : "Not Found"),
            SizedBox(
              height: 20,
            ),
            ...List.generate(
              _stream.length,
              (index) => Text("Hello World"),
            ),
          ],
        ),
      ),
    );
  }
}
