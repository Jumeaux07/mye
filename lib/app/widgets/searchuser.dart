import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NearbyUsersMap extends StatefulWidget {
  @override
  _NearbyUsersMapState createState() => _NearbyUsersMapState();
}

class _NearbyUsersMapState extends State<NearbyUsersMap> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  final double _searchRadius = 5000; // Rayon de recherche en mètres

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _addCurrentLocationMarker();
      });

      // Rechercher les utilisateurs à proximité
      await _searchNearbyUsers();
    } catch (e) {
      print('Erreur de localisation: $e');
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: InfoWindow(title: 'Ma position'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
  }

  Future<void> _searchNearbyUsers() async {
    if (_currentPosition == null) return;

    // Calculer les limites de la zone de recherche
    double lat = _currentPosition!.latitude;
    double lon = _currentPosition!.longitude;

    // Conversion approximative de degrés en mètres
    double latRadius = _searchRadius / 111320.0;
    double lonRadius = _searchRadius / (111320.0 * cos(lat * pi / 180));

    // Requête Firestore pour trouver les utilisateurs à proximité
    final nearbyUsers = await FirebaseFirestore.instance
        .collection('users')
        .where('location.latitude', isGreaterThan: lat - latRadius)
        .where('location.latitude', isLessThan: lat + latRadius)
        .get();

    setState(() {
      for (var doc in nearbyUsers.docs) {
        // Filtrer davantage pour la longitude
        double userLat = doc.data()['location']['latitude'];
        double userLon = doc.data()['location']['longitude'];

        if (userLon >= lon - lonRadius && userLon <= lon + lonRadius) {
          _markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(userLat, userLon),
              infoWindow: InfoWindow(
                title: doc.data()['name'] ?? 'Utilisateur',
                snippet: 'Cliquez pour plus d\'infos',
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: _searchNearbyUsers,
        child: Icon(Icons.refresh),
        tooltip: 'Actualiser la recherche',
      ),
    );
  }
}
