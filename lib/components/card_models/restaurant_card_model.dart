import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:r2re/screens/feed_screen/restaurant_page/restaurant_page.dart';
import 'package:r2re/state_management/favourite_provider.dart';

class RestaurantCardModel extends StatefulWidget {
  final Map<String, dynamic> data;

  const RestaurantCardModel({super.key, required this.data});

  @override
  State<RestaurantCardModel> createState() => _RestaurantCardModelState();
}

class _RestaurantCardModelState extends State<RestaurantCardModel> {
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
          setState(
            () {
              distanceInMeter = Geolocator.distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                restaurantLat,
                restaurantLng,
              );
              distanceInKm = distanceInMeter! / 1000;
            },
          );
        }
      }
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position? position) {
          if (_mounted) {}
        },
      );
      positionStream;
    } catch (e) {
      return;
    }
  }

  num getHighestRate() {
    num highestRate = 0;
    Map<String, dynamic> deals = widget.data['deals'] ?? {};
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

  String rewordedAddress(String text) {
    int index = text.indexOf(' ');
    if (index != -1) {
      return text.substring(index + 1);
    } else {
      return text;
    }
  }

  @override
  void initState() {
    super.initState();
    _mounted = true;
    calculateDistance();
  }

  @override
  void dispose() {
    _mounted = false;
    calculateDistance();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    num highestRate = getHighestRate();
    String address = rewordedAddress(widget.data["address"]);

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => RestaurantPage(
                  data: widget.data,
                )));
      },
      child: SizedBox(
        height: 230,
        width: 190,
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
                child: (widget.data["image"] != null)
                    ? Image(
                        height: 100,
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.data["image"]),
                      )
                    : const Image(
                        height: 100,
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/basic_photo.png"),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        widget.data["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 18,
                        maxFontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: (widget.data["address"] != null)
                            ? AutoSizeText(
                                address,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                minFontSize: 14,
                                maxFontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const AutoSizeText(
                                '',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                minFontSize: 14,
                                maxFontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      Expanded(
                        child: (widget.data["geo"] != null)
                            ? AutoSizeText(
                                '${distanceInKm!.toStringAsFixed(1)}km 근처',
                                style: const TextStyle(fontSize: 16),
                                minFontSize: 14,
                                maxFontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const AutoSizeText(
                                '-km 근처',
                                style: TextStyle(fontSize: 16),
                                minFontSize: 14,
                                maxFontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                size: 18,
                                Icons.discount,
                                color: Colors.purple,
                              ),
                            ),
                            AutoSizeText(
                              ' 최대 $highestRate%딜',
                              style: const TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              minFontSize: 10,
                              maxFontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                children: [
                                  (currentUser != null)
                                      ? FutureBuilder<bool>(
                                          future: favouritesProvider.isLiked(
                                              currentUser.uid,
                                              widget.data["name"],
                                              widget.data["unique"]),
                                          builder: (context, snapshot) {
                                            bool isLiked =
                                                snapshot.data ?? false;
                                            return GestureDetector(
                                              onTap: () {
                                                if (isLiked) {
                                                  favouritesProvider
                                                      .removeFavoriteItem(
                                                          currentUser.uid,
                                                          widget.data["name"],
                                                          widget
                                                              .data["unique"]);
                                                } else {
                                                  favouritesProvider
                                                      .addFavoriteItem(
                                                          currentUser.uid,
                                                          widget.data["name"],
                                                          widget
                                                              .data["unique"]);
                                                }
                                              },
                                              child: Icon(
                                                isLiked
                                                    ? CupertinoIcons.heart_fill
                                                    : CupertinoIcons.heart,
                                                color: isLiked
                                                    ? Colors.pink
                                                    : Colors.grey,
                                                size: 24,
                                              ),
                                            );
                                          },
                                        )
                                      : const Icon(
                                          CupertinoIcons.heart,
                                          color: Colors.grey,
                                          size: 24,
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
            ],
          ),
        ),
      ),
    );
  }
}
