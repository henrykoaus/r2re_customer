import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:r2re/constants/screen_size.dart';

class MyFavouriteDealCardModel extends StatefulWidget {
  final Map<String, dynamic> data;

  const MyFavouriteDealCardModel({super.key, required this.data});

  @override
  State<MyFavouriteDealCardModel> createState() =>
      _MyFavouriteDealCardModelState();
}

class _MyFavouriteDealCardModelState extends State<MyFavouriteDealCardModel> {
  double? distanceInMeter = 0.0;
  double? distanceInKm = 0.0;
  bool _mounted = false;

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

  num getHighestRate() {
    num highestRate = 0;
    Map<String, dynamic> deals = widget.data['deals'] ?? {};
    deals.forEach((key, value) {
      num rate = value['rate'] ?? 0;
      if (rate > highestRate) {
        highestRate = rate;
      } else {
        highestRate = 0;
      }
    });
    return highestRate;
  }

  @override
  void initState() {
    _mounted = true;
    calculateDistance();
    super.initState();
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
    num highestRate = getHighestRate();

    return SizedBox(
      height: widgetSize / 8,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: (widget.data["image"] != null)
                    ? Container(
                        height: widgetSize / 10,
                        width: widgetSize / 10,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.data["image"]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                      )
                    : Container(
                        height: widgetSize / 10,
                        width: widgetSize / 10,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/basic_photo.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
                      widget.data["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 10,
                      maxFontSize: 22,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Expanded(
                      child: (widget.data["address"] != null)
                          ? AutoSizeText(
                              widget.data["address"],
                              style: const TextStyle(fontSize: 13),
                              minFontSize: 10,
                              maxFontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const AutoSizeText(
                              '',
                              style: TextStyle(fontSize: 13),
                              minFontSize: 10,
                              maxFontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    Expanded(
                      child: (widget.data["geo"] != null)
                          ? AutoSizeText(
                              '${distanceInKm!.toStringAsFixed(1)}km 근처',
                              style: const TextStyle(fontSize: 13),
                              minFontSize: 10,
                              maxFontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const AutoSizeText(
                              '-km 근처',
                              style: TextStyle(fontSize: 13),
                              minFontSize: 10,
                              maxFontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            size: 15,
                            Icons.discount,
                            color: Colors.purple,
                          ),
                          AutoSizeText(
                            ' 최대 $highestRate% 딜',
                            style: const TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            minFontSize: 10,
                            maxFontSize: 22,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
