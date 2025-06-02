import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:r2re/env/env.dart';
import 'package:r2re/screens/feed_screen/restaurant_page/restaurant_page_body/business_info.dart';
import 'package:r2re/screens/feed_screen/card_displays/rep_menu_display.dart';
import 'package:r2re/screens/feed_screen/restaurant_page/restaurant_page_body/restaurant_info.dart';
import 'package:r2re/screens/feed_screen/restaurant_page/restaurant_page_body/ontap_map_page.dart';

class RestaurantPageBody extends StatefulWidget {
  final Map<String, dynamic> data;

  const RestaurantPageBody({super.key, required this.data});

  @override
  State<RestaurantPageBody> createState() => _RestaurantPageBodyState();
}

class _RestaurantPageBodyState extends State<RestaurantPageBody> {
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
    GeoPoint restaurantGeoPoint = widget.data["geo"];
    double restaurantLat = restaurantGeoPoint.latitude;
    double restaurantLng = restaurantGeoPoint.longitude;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: (widget.data["address"] != null)
                  ? SelectableText(
                      widget.data["address"],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      '등록된 주소가 아직 없습니다.',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: (widget.data["geo"] != null)
                  ? Text(
                      '${distanceInKm!.toStringAsFixed(1)}km 근처',
                      style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      '-km 근처',
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            staticMap(restaurantLng, restaurantLat, context),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '가게소개',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: (widget.data["intro"] != null)
                        ? Text(
                            widget.data["intro"],
                            style: const TextStyle(fontSize: 16),
                          )
                        : const SizedBox(
                            height: 60,
                            child: Center(
                              child: Text(
                                '등록된 가게소개글이 아직 없습니다.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '대표메뉴',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RepMenuDisplay(
                    data: widget.data,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RestaurantInfo(data: widget.data),
                  const SizedBox(
                    height: 15,
                  ),
                  BusinessInfo(data: widget.data),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center staticMap(
      double restaurantLng, double restaurantLat, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100]),
                child: Image.network(
                  'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?crs=EPSG:4326&scale=2&format=png&w=300&h=200&markers=type:t|size:mid|pos:$restaurantLng $restaurantLat|label:${widget.data["name"]}',
                  headers: {
                    "X-NCP-APIGW-API-KEY-ID": Env.naver_map,
                    "X-NCP-APIGW-API-KEY": Env.naver_map_secret,
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('지도를 불러오는 중입니다.'));
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () async {
                  await NaverMapSdk.instance.initialize(
                      clientId: Env.naver_map,
                      onAuthFailed: (e) =>
                          log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => OnTapMapPage(
                          data: widget.data,
                        ),
                      ),
                    );
                  }
                },
                child: InkWell(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink,
                            blurRadius: .5,
                          ),
                        ]),
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.pinkAccent,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
