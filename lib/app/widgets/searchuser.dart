import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import '../modules/messagerie/views/messagerie_view.dart';
import '../data/constant.dart';

class NearbyUsersMap extends StatefulWidget {
  @override
  _NearbyUsersMapState createState() => _NearbyUsersMapState();
}

class _NearbyUsersMapState extends State<NearbyUsersMap> {
  MapController? _mapController;
  Position? _currentPosition;
  List<Marker> _markers = [];
  final double _searchRadius = 5000;
  final homeController = Get.put(HomeController());
  final conversationController = Get.find<ConversationController>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      while (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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

  void _addCurrentLocationMarker() {
    if (_currentPosition != null) {
      _markers.add(Marker(
        point: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // Gérer le tap sur le marqueur
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: Env.userAuth.profileImage != null
                    ? NetworkImage(Env.userAuth.profileImage!)
                    : null,
                child: Env.userAuth.profileImage == null
                    ? Icon(Icons.person)
                    : null,
              ),
              Text(
                'Moi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ));
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
        newMarkers.add(
          Marker(
            point: LatLng(userLat, userLon),
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () {
                if (Env.userAuth.isPremium == 1) {
                  conversationController.openNewDiscussion(user);
                } else {
                  Get.toNamed(Routes.ABONNEMENT);
                }
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage!)
                        : null,
                    child:
                        user.profileImage == null ? Icon(Icons.person) : null,
                  ),
                  Text(
                    user.pseudo ?? 'Utilisateur',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          initialZoom: 14.0,
          onTap: (tapPosition, point) {
            // Gérer le tap sur la carte
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_currentPosition != null && _mapController != null) {
                _mapController!.move(
                  LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
                  14.0,
                );
              }
            },
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _searchNearbyUsers,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
