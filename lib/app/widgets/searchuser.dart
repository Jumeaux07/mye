import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/widgets/custom_marcker.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../data/constant.dart';
import '../modules/messagerie/views/messagerie_view.dart';

class NearbyUsersMap extends StatefulWidget {
  @override
  _NearbyUsersMapState createState() => _NearbyUsersMapState();
}

class _NearbyUsersMapState extends State<NearbyUsersMap> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  final double _searchRadius = 5000; // Rayon de recherche en mètres
  final homeController = Get.put(HomeController());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // _startTimer();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      if (mounted) {
        _searchNearbyUsers();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      while (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      printInfo(info: "long ${position.longitude} lat ${position.latitude}");

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _addCurrentLocationMarker();
        });
      }

      await _searchNearbyUsers();
    } catch (e) {
      print('Erreur de localisation: $e');
    }
  }

  Future<void> _addCurrentLocationMarker() async {
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          onTap: () {
            // Get.to(() => MessagerieView());
          },
          markerId: MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: InfoWindow(title: 'Ma position'),
          icon: await CustomMarcker(
            text: 'Ma position',
            image: Env.userAuth.profileImage ?? null,
          ).toBitmapDescriptor(),
        ),
      );
    }
  }

  Future<void> _searchNearbyUsers() async {
    if (_currentPosition == null) return;

    double lat = _currentPosition!.latitude;
    double lon = _currentPosition!.longitude;

    double latRadius = _searchRadius / 111320.0;
    double lonRadius = _searchRadius / (111320.0 * cos(lat * pi / 180));

    final nearbyUsers = await homeController.userList;
    List<Marker> newMarkers = [];

    for (var user in nearbyUsers) {
      double userLat = user.latitude ?? 0.00;
      double userLon = user.longitude ?? 0.00;

      if (userLon >= lon - lonRadius && userLon <= lon + lonRadius) {
        BitmapDescriptor icon = await CustomMarcker(
          text: user.pseudo ?? 'Utilisateur',
          image: user.profileImage ?? null,
        ).toBitmapDescriptor();

        newMarkers.add(
          Marker(
            onTap: () {
              if (Env.userAuth.isPremium == 1) {
                Get.to(() => MessagerieView());
              }
            },
            markerId: MarkerId(user.id.toString()),
            position: LatLng(userLat, userLon),
            icon: icon,
            infoWindow: InfoWindow(
              title: user.pseudo ?? 'Utilisateur',
              snippet: 'Longue pression pour plus d\'infos',
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _markers.addAll(newMarkers);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _searchNearbyUsers();
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 14,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _searchNearbyUsers();
        },
        child: Icon(Icons.refresh),
        tooltip: 'Actualiser la recherche',
      ),
    );
  }
}
