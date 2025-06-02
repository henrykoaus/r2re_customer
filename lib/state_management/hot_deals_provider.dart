import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HotDealsProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> _hotDealsDocs = [];
  List<QueryDocumentSnapshot> _filteredDocs = [];

  List<QueryDocumentSnapshot> get hotDealsDocs => _hotDealsDocs;
  List<QueryDocumentSnapshot> get filteredDocs => _filteredDocs;

  final CollectionReference restaurantDataCollection =
      FirebaseFirestore.instance.collection('restaurantData');

  Future<List<QueryDocumentSnapshot>> setMaxDistance(
      List<QueryDocumentSnapshot> restaurants, double maxDistanceInKm) async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        return restaurants.where((restaurant) {
          GeoPoint restaurantGeoPoint = restaurant['geo'];
          double distanceInKm = Geolocator.distanceBetween(
                  lastKnownPosition.latitude,
                  lastKnownPosition.longitude,
                  restaurantGeoPoint.latitude,
                  restaurantGeoPoint.longitude) /
              1000;
          return distanceInKm < maxDistanceInKm;
        }).toList();
      } else {
        return restaurants;
      }
    } catch (error) {
      rethrow;
    }
  }

  List<QueryDocumentSnapshot> sortRestaurantsByDistance(
      List<QueryDocumentSnapshot> restaurants, Position userLocation) {
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

  num getHighestRate(Map<String, dynamic> deals) {
    num highestRate = 0;
    deals.forEach(
      (key, value) {
        num rate = value['rate'] ?? 0;
        if (rate > highestRate) {
          highestRate = rate;
        }
      },
    );
    return highestRate;
  }

  Future<void> fetchHotDealsRestaurants(String searchQuery) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _hotDealsDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _hotDealsDocs = _hotDealsDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      _hotDealsDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('deals');
      }).toList();
      _hotDealsDocs = _hotDealsDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['deals'] as Map<String, dynamic>;
        num highestRate = 0;
        data.forEach(
          (key, value) {
            num rate = value['rate'] ?? 0;
            if (rate > highestRate) {
              highestRate = rate;
            }
          },
        );
        return highestRate >= 50;
      }).toList();
      if (searchQuery.isEmpty) {
        _filteredDocs = List.from(_hotDealsDocs);
      } else {
        _filteredDocs = _hotDealsDocs.where(
          (doc) {
            final restaurantData = doc.data() as Map<String, dynamic>;
            final restaurantName =
                restaurantData['name'].toString().toLowerCase();
            return restaurantName.contains(searchQuery.toLowerCase());
          },
        ).toList();
      }
      _filteredDocs.sort(
        (a, b) {
          final aHighestRate =
              getHighestRate(a.get('deals') as Map<String, dynamic>);
          final bHighestRate =
              getHighestRate(b.get('deals') as Map<String, dynamic>);
          if (aHighestRate == 0 && bHighestRate == 0) {
            return 0;
          } else if (aHighestRate == 0) {
            return 1;
          } else if (bHighestRate == 0) {
            return -1;
          } else {
            return bHighestRate.compareTo(aHighestRate);
          }
        },
      );
      _filteredDocs = await setMaxDistance(_filteredDocs, 10000);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
