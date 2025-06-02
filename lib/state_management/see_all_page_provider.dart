import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SeeAllPageProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> _allDocs = [];
  List<QueryDocumentSnapshot> _nearbyDocs = [];
  List<QueryDocumentSnapshot> _popularDocs = [];
  List<QueryDocumentSnapshot> _greatDealDocs = [];
  List<QueryDocumentSnapshot> _regionDocs = [];
  List<QueryDocumentSnapshot> _categoryDocs = [];
  List<QueryDocumentSnapshot> _filteredDocs = [];

  List<QueryDocumentSnapshot> get allDocs => _allDocs;
  List<QueryDocumentSnapshot> get nearbyDocs => _nearbyDocs;
  List<QueryDocumentSnapshot> get popularDocs => _popularDocs;
  List<QueryDocumentSnapshot> get greatDealDocs => _greatDealDocs;
  List<QueryDocumentSnapshot> get regionDocs => _regionDocs;
  List<QueryDocumentSnapshot> get categoryDocs => _categoryDocs;
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

  Future<void> fetchAllRestaurants(String searchQuery) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _allDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _allDocs = _allDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      if (searchQuery.isEmpty) {
        _filteredDocs = List.from(_allDocs);
      } else {
        _filteredDocs = _allDocs.where(
          (doc) {
            final restaurantData = doc.data() as Map<String, dynamic>;
            final restaurantName =
                restaurantData['name'].toString().toLowerCase();
            return restaurantName.contains(searchQuery.toLowerCase());
          },
        ).toList();
      }
      _filteredDocs = await setMaxDistance(_filteredDocs, 10000);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchGreatDealRestaurants(String searchQuery) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _greatDealDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _greatDealDocs = _greatDealDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      _greatDealDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('deals');
      }).toList();
      if (searchQuery.isEmpty) {
        _filteredDocs = List.from(_greatDealDocs);
      } else {
        _filteredDocs = _greatDealDocs.where(
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

  Future<void> fetchPopularRestaurants(String searchQuery) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _popularDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _popularDocs = _popularDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      _popularDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('likes');
      }).toList();
      _filteredDocs = _popularDocs.where(
        (doc) {
          final restaurantData = doc.data() as Map<String, dynamic>;
          final restaurantName =
              restaurantData['name'].toString().toLowerCase();
          return restaurantName.contains(searchQuery.toLowerCase());
        },
      ).toList();
      _filteredDocs.sort((a, b) =>
          (b['likes']?.length ?? 0).compareTo(a['likes']?.length ?? 0));
      _filteredDocs = await setMaxDistance(_filteredDocs, 10000);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchNearbyRestaurants(String searchQuery) async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _nearbyDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _nearbyDocs = _nearbyDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      if (searchQuery.isEmpty) {
        _filteredDocs = List.from(_nearbyDocs);
      } else {
        _filteredDocs = _nearbyDocs.where((doc) {
          final restaurantData = doc.data() as Map<String, dynamic>;
          final restaurantName =
              restaurantData['name'].toString().toLowerCase();
          return restaurantName.contains(searchQuery.toLowerCase());
        }).toList();
      }
      _filteredDocs = await setMaxDistance(_filteredDocs, 10000);
      _filteredDocs =
          sortRestaurantsByDistance(_filteredDocs, lastKnownPosition!);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchRestaurantsByRegion(
      String region, String searchQuery) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _regionDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _regionDocs = _regionDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      _regionDocs = _regionDocs.where(
        (doc) {
          final restaurantData = doc.data() as Map<String, dynamic>;
          return restaurantData['region'] == region;
        },
      ).toList();
      if (searchQuery.isEmpty) {
        _filteredDocs = List.from(_regionDocs);
      } else {
        _filteredDocs = _regionDocs.where(
          (doc) {
            final restaurantData = doc.data() as Map<String, dynamic>;
            final restaurantName =
                restaurantData['name'].toString().toLowerCase();
            return restaurantName.contains(searchQuery.toLowerCase());
          },
        ).toList();
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchRestaurantsByCategory(
      String category, String searchQuery) async {
    try {
      QuerySnapshot snapshot = await restaurantDataCollection.get();
      _categoryDocs = snapshot.docs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        return restaurantData.containsKey('isOpen');
      }).toList();
      _categoryDocs = _categoryDocs.where((doc) {
        final restaurantData = doc.data() as Map<String, dynamic>;
        final data = restaurantData['isOpen'] as bool;
        return data == true;
      }).toList();
      _categoryDocs = _categoryDocs.where(
        (doc) {
          final restaurantData = doc.data() as Map<String, dynamic>;
          return restaurantData['category'] == category;
        },
      ).toList();
      if (searchQuery.isEmpty) {
        _filteredDocs = List.from(_categoryDocs);
      } else {
        _filteredDocs = _categoryDocs.where(
          (doc) {
            final restaurantData = doc.data() as Map<String, dynamic>;
            final restaurantName =
                restaurantData['name'].toString().toLowerCase();
            return restaurantName.contains(searchQuery.toLowerCase());
          },
        ).toList();
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
