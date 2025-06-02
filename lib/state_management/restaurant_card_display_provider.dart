import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantCardDisplayProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _allRestaurants = [];
  List<Map<String, dynamic>> _nearbyRestaurants = [];
  List<Map<String, dynamic>> _popularRestaurants = [];
  List<Map<String, dynamic>> _greatDealRestaurants = [];
  List<Map<String, dynamic>> _favouriteRestaurants = [];

  List<Map<String, dynamic>> get allRestaurants => _allRestaurants;
  List<Map<String, dynamic>> get nearbyRestaurants => _nearbyRestaurants;
  List<Map<String, dynamic>> get popularRestaurants => _popularRestaurants;
  List<Map<String, dynamic>> get greatDealRestaurants => _greatDealRestaurants;
  List<Map<String, dynamic>> get favouriteRestaurants => _favouriteRestaurants;

  final restaurantDataCollection =
      FirebaseFirestore.instance.collection('restaurantData');
  final userDataCollection = FirebaseFirestore.instance.collection('userData');

  Future<List<Map<String, dynamic>>> setMaxDistance(
      List<Map<String, dynamic>> restaurants, double maxDistanceInKm) async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        return restaurants.where(
          (restaurant) {
            GeoPoint restaurantGeoPoint = restaurant['geo'];
            double distanceInKm = Geolocator.distanceBetween(
                    lastKnownPosition.latitude,
                    lastKnownPosition.longitude,
                    restaurantGeoPoint.latitude,
                    restaurantGeoPoint.longitude) /
                1000;
            return distanceInKm < maxDistanceInKm;
          },
        ).toList();
      } else {
        return restaurants;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> sortRestaurantsByDistance(
      List<Map<String, dynamic>> restaurants, Position userLocation) async {
    return restaurants
      ..sort(
        (a, b) {
          GeoPoint aGeoPoint = a['geo'];
          GeoPoint bGeoPoint = b['geo'];
          return Geolocator.distanceBetween(
                  userLocation.latitude,
                  userLocation.longitude,
                  aGeoPoint.latitude,
                  aGeoPoint.longitude)
              .compareTo(Geolocator.distanceBetween(
                  userLocation.latitude,
                  userLocation.longitude,
                  bGeoPoint.latitude,
                  bGeoPoint.longitude));
        },
      );
  }

  Future<void> fetchAllRestaurants() async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _allRestaurants = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["isOpen"] != null && data["isOpen"] == true) {
          _allRestaurants.add(data);
        }
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchGreatDealRestaurants() async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _greatDealRestaurants = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["isOpen"] != null && data["isOpen"] == true) {
          _greatDealRestaurants.add(data);
          if (data["deals"] != null) {
            _greatDealRestaurants.sort(
              (a, b) {
                Map<String, dynamic> aDeals = a['deals'];
                Map<String, dynamic> bDeals = b['deals'];
                num aHighestRate = aDeals.values
                    .map((deal) => (deal['rate'] ?? 0) as num)
                    .reduce(max);
                num bHighestRate = bDeals.values
                    .map((deal) => (deal['rate'] ?? 0) as num)
                    .reduce(max);
                return bHighestRate.compareTo(aHighestRate);
              },
            );
          }
        }
      }
      _greatDealRestaurants =
          await setMaxDistance(_greatDealRestaurants, 10000);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchPopularRestaurants() async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _popularRestaurants = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["isOpen"] != null && data["isOpen"] == true) {
          _popularRestaurants.add(data);
          _popularRestaurants.sort((a, b) =>
              (b['likes']?.length ?? 0).compareTo(a['likes']?.length ?? 0));
        }
      }
      _popularRestaurants = await setMaxDistance(_popularRestaurants, 10000);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchNearbyRestaurants() async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _nearbyRestaurants = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["isOpen"] != null && data["isOpen"] == true) {
          _nearbyRestaurants.add(data);
        }
      }
      _nearbyRestaurants = await setMaxDistance(_nearbyRestaurants, 10000);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchFavouriteRestaurants(String userUid) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _favouriteRestaurants = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["isOpen"] != null &&
            data["isOpen"] == true &&
            data['likes'] != null &&
            data['likes'].contains(userUid)) {
          _favouriteRestaurants.add(data);
        }
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
