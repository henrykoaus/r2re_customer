import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PurchasedDealsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _eachPurchasedDeal = [];
  List<Map<String, dynamic>> _purchasedDeals = [];
  List<QueryDocumentSnapshot> _allPurchasedDeals = [];
  List<QueryDocumentSnapshot> _filteredPurchasedDeals = [];
  List<Map<String, dynamic>> _dealsPaymentHistory = [];
  List<Map<String, dynamic>> _dealsPurchaseHistory = [];
  num _totalBalance = 0;

  List<Map<String, dynamic>> get eachPurchasedDeal => _eachPurchasedDeal;
  List<Map<String, dynamic>> get purchasedDeals => _purchasedDeals;
  List<QueryDocumentSnapshot> get allPurchasedDeals => _allPurchasedDeals;
  List<QueryDocumentSnapshot> get filteredPurchasedDeals =>
      _filteredPurchasedDeals;
  List<Map<String, dynamic>> get dealsPaymentHistory => _dealsPaymentHistory;
  List<Map<String, dynamic>> get dealsPurchaseHistory => _dealsPurchaseHistory;
  num get totalBalance => _totalBalance;
  final userDataCollection = FirebaseFirestore.instance.collection('userData');

  Future<void> fetchEachPurchasedDeal(String userUid, String unique) async {
    try {
      final eachPurchasedDealRef = userDataCollection
          .doc(userUid)
          .collection("purchasedDeals")
          .doc(unique)
          .collection('subCollection');
      final subCollectionSnapshot = await eachPurchasedDealRef.get();
      final eachPurchasedDealList = subCollectionSnapshot.docs
          .where((doc) => doc.data()['balance'] != 0)
          .map((doc) => doc.data())
          .toList();
      _eachPurchasedDeal = eachPurchasedDealList;
      for (final doc in subCollectionSnapshot.docs) {
        if (doc.data()['balance'] == 0) {
          await doc.reference.delete();
        }
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchPurchasedDeals(String userUid) async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      QuerySnapshot<Map<String, dynamic>> snapshot = await userDataCollection
          .doc(userUid)
          .collection("purchasedDeals")
          .get();
      for (final doc in snapshot.docs) {
        bool hasSubCollections = false;
        final subCollectionSnapshot =
            await doc.reference.collection("subCollection").get();
        if (subCollectionSnapshot.docs.isNotEmpty) {
          hasSubCollections = true;
        }
        if (!hasSubCollections) {
          await doc.reference.delete();
        }
      }
      _purchasedDeals = snapshot.docs.map((doc) => doc.data()).toList();
      _purchasedDeals =
          sortRestaurantsDisplayByDistance(_purchasedDeals, lastKnownPosition!);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> fetchAllPurchasedDeals(
      String userUid, String searchQuery) async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      QuerySnapshot<Map<String, dynamic>> snapshot = await userDataCollection
          .doc(userUid)
          .collection("purchasedDeals")
          .get();
      _allPurchasedDeals = snapshot.docs.toList();
      if (searchQuery.isEmpty) {
        _filteredPurchasedDeals = List.from(_allPurchasedDeals);
      } else {
        _filteredPurchasedDeals = _allPurchasedDeals.where((doc) {
          final restaurantData = doc.data() as Map<String, dynamic>;
          final restaurantName =
              restaurantData['name'].toString().toLowerCase();
          return restaurantName.contains(searchQuery.toLowerCase());
        }).toList();
      }
      _filteredPurchasedDeals = sortRestaurantsSeeAllPageByDistance(
          _filteredPurchasedDeals, lastKnownPosition!);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchDealsPaymentHistory(String userUid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> dealsPaymentHistorySnapshot =
          await userDataCollection
              .doc(userUid)
              .collection("paymentHistory")
              .doc("purchasedDeals")
              .collection('subCollection')
              .orderBy('paymentRequestTime', descending: true)
              .get();
      final docs = dealsPaymentHistorySnapshot.docs;
      final subCollectionDocsData = docs.map((doc) => doc.data()).toList();
      _dealsPaymentHistory = subCollectionDocsData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchDealsPurchaseHistory(String userUid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> dealsPurchaseHistorySnapshot =
          await userDataCollection
              .doc(userUid)
              .collection("transactionHistory")
              .doc("purchasedDeals")
              .collection('subCollection')
              .orderBy('paidTime', descending: true)
              .get();
      final docs = dealsPurchaseHistorySnapshot.docs;
      final subCollectionDocsData = docs.map((doc) => doc.data()).toList();
      _dealsPurchaseHistory = subCollectionDocsData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> calculateTotalBalance(String userUid) async {
    try {
      num totalBalance = 0;
      QuerySnapshot<Map<String, dynamic>> purchasedDealsDocs =
          await userDataCollection
              .doc(userUid)
              .collection("purchasedDeals")
              .get();
      for (var purchasedDealsDoc in purchasedDealsDocs.docs) {
        QuerySnapshot<Map<String, dynamic>> subCollectionDocs =
            await purchasedDealsDoc.reference.collection("subCollection").get();
        for (var subDocument in subCollectionDocs.docs) {
          totalBalance += subDocument.data()['balance'] ?? 0;
        }
      }
      _totalBalance = totalBalance;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Map<String, dynamic>> sortRestaurantsDisplayByDistance(
      List<Map<String, dynamic>> restaurants, Position userLocation) {
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

  List<QueryDocumentSnapshot> sortRestaurantsSeeAllPageByDistance(
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
}
