import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r2re/components/dialogs.dart';

class OnTapMapPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const OnTapMapPage({super.key, required this.data});

  @override
  State<OnTapMapPage> createState() => _OnTapMapPageState();
}

class _OnTapMapPageState extends State<OnTapMapPage> {
  NaverMapController? _mapController;
  NLatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    getLocation();
    loadData();
  }

  getLocation() async {
    Position? position;
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isGranted || status.isLimited) {
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double lat = position.latitude;
        double long = position.longitude;
        NLatLng location = NLatLng(lat, long);
        if (mounted) {
          setState(() {
            currentPosition = location;
          });
        }
      }
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      if (mounted) {
        settingDialog(context);
      }
    } else if (status.isRestricted) {
      if (mounted) {
        settingDialog(context);
      }
    } else if (status.isDenied) {
      if (mounted) {
        settingDialog(context);
      }
    }
  }

  loadData() async {
    GeoPoint restaurantGeoPoint = widget.data["geo"];
    double restaurantLat = restaurantGeoPoint.latitude;
    double restaurantLng = restaurantGeoPoint.longitude;
    const iconImage = NOverlayImage.fromAssetImage('assets/icon/map_icon.png');
    final marker = NMarker(
      id: widget.data["name"],
      icon: iconImage,
      size: const Size(40, 40),
      position: NLatLng(restaurantLat, restaurantLng),
      caption: NOverlayCaption(text: widget.data["name"], textSize: 16),
      subCaption: NOverlayCaption(text: widget.data["category"], textSize: 12),
      isHideCollidedMarkers: true,
    );
    _mapController?.addOverlay(marker);
    marker.setOnTapListener(
      (NMarker marker) {
        _mapController?.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: marker.position,
            zoom: 16,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    getLocation();
    loadData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GeoPoint restaurantGeoPoint = widget.data["geo"];
    double restaurantLat = restaurantGeoPoint.latitude;
    double restaurantLng = restaurantGeoPoint.longitude;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  NaverMap(
                    options: NaverMapViewOptions(
                      //extent: const NLatLngBounds(southWest: NLatLng(31.43, 122.37),northEast: NLatLng(44.35, 132.0),),
                      rotationGesturesEnable: false,
                      tiltGesturesEnable: false,
                      locationButtonEnable: true,
                      initialCameraPosition: NCameraPosition(
                          target: NLatLng(restaurantLat, restaurantLng),
                          zoom: 16.0),
                    ),
                    onMapReady: (controller) async {
                      _mapController = controller;
                      await loadData();
                    },
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Material(
                          elevation: 3,
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30.0),
                          child: IconButton(
                            splashRadius: 19.0,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.pink,
                            ),
                            onPressed: () {
                              Navigator.maybePop(context);
                            },
                          ),
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
    );
  }
}
