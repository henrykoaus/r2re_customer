import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:r2re/components/see_all_page_models/see_all_pruchased_items_model.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/components/card_models/purchased_card_models/balance_card_model.dart';

class PurchasedDealCardModel extends StatefulWidget {
  final Map<String, dynamic> data;
  final double imageSize;

  const PurchasedDealCardModel({
    super.key,
    required this.data,
    required this.imageSize,
  });

  @override
  State<PurchasedDealCardModel> createState() => _PurchasedDealCardModelState();
}

class _PurchasedDealCardModelState extends State<PurchasedDealCardModel> {
  double? distanceInMeter = 0.0;
  double? distanceInKm = 0.0;
  num purchasedDealsTotalBalance = 0;
  bool _mounted = false;
  bool _isLoading = true;
  final currentUser = FirebaseAuth.instance.currentUser;
  final userDataCollection = FirebaseFirestore.instance.collection('userData');
  final restaurantDataCollection =
      FirebaseFirestore.instance.collection('restaurantData');
  String? image;

  Future<void> calculateDistance() async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      GeoPoint restaurantGeoPoint = widget.data["geo"];
      double restaurantLat = restaurantGeoPoint.latitude;
      double restaurantLng = restaurantGeoPoint.longitude;
      if (lastKnownPosition != null && _mounted) {
        setState(() {
          distanceInMeter = Geolocator.distanceBetween(
            lastKnownPosition.latitude,
            lastKnownPosition.longitude,
            restaurantLat,
            restaurantLng,
          );
          distanceInKm = distanceInMeter! / 1000;
        });
      } else {
        Position? currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (lastKnownPosition == null && _mounted) {
          setState(() {
            distanceInMeter = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              restaurantLat,
              restaurantLng,
            );
            distanceInKm = distanceInMeter! / 1000;
          });
        }
      }
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      );
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (_mounted) {}
      });
      positionStream;
    } catch (e) {
      return;
    }
  }

  Future<void> calculatePurchasedDealsTotalBalance() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> mainDocumentSnapshot =
          await userDataCollection
              .doc(currentUser!.uid)
              .collection('purchasedDeals')
              .doc(widget.data["unique"])
              .get();
      if (mainDocumentSnapshot.exists) {
        purchasedDealsTotalBalance +=
            mainDocumentSnapshot.data()?['balance'] ?? 0;
        QuerySnapshot<Map<String, dynamic>> subCollectionsSnapshot =
            await mainDocumentSnapshot.reference
                .collection("subCollection")
                .get();
        for (var subDocument in subCollectionsSnapshot.docs) {
          purchasedDealsTotalBalance += subDocument.data()['balance'] ?? 0;
        }
        if (mounted) {
          setState(() {
            purchasedDealsTotalBalance;
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchImage() async {
    final docRef = restaurantDataCollection.doc(widget.data["unique"]);
    docRef.snapshots().listen(
      (docSnapshot) {
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          image = data['image'];
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _mounted = true;
    calculateDistance();
    calculatePurchasedDealsTotalBalance();
  }

  @override
  void dispose() {
    _mounted = false;
    calculateDistance();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widgetSize = size!.height;
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => SeeAllPurchasedItemsModel(
              unique: widget.data["unique"],
              title: widget.data["name"],
            ),
          ),
        );
      },
      child: Stack(
        children: [
          SizedBox(
            height: widgetSize / 8,
            child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: fetchImage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            height: widgetSize / widget.imageSize,
                            width: widgetSize / widget.imageSize,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/basic_photo.png"),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                          );
                        } else {
                          return Container(
                            height: widgetSize / widget.imageSize,
                            width: widgetSize / widget.imageSize,
                            decoration: BoxDecoration(
                              image: (image != null)
                                  ? DecorationImage(
                                      image: NetworkImage(image!),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/basic_photo.png"),
                                      fit: BoxFit.fill,
                                    ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Center(
                              child: AutoSizeText(
                                widget.data["name"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                minFontSize: 18,
                                maxFontSize: 22,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: (widget.data["geo"] != null)
                                ? AutoSizeText(
                                    '${distanceInKm!.toStringAsFixed(1)}km 근처',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    minFontSize: 12,
                                    maxFontSize: 22,
                                  )
                                : const AutoSizeText(
                                    '-km 근처',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    minFontSize: 12,
                                    maxFontSize: 22,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: widgetSize / 9,
                      width: widgetSize / 9,
                      child: _isLoading
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 3),
                              ),
                            )
                          : BalanceCardModel(
                              amount: purchasedDealsTotalBalance,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.discount,
                color: Colors.purple,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
