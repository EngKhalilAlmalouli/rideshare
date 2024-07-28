import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/colors.dart';
import 'package:rideshare/text_button.dart';

class HomeScreenTransport extends StatefulWidget {
  const HomeScreenTransport({super.key});

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> {
  // final Completer<GoogleMapController> completerController =
  //     Completer<GoogleMapController>();
  GoogleMapController? _controller;
  bool selectText = true;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.51020000, 36.29128000),
    zoom: 14.4746,
  );

  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  BitmapDescriptor? markerIcon;

  @override
  void initState() {
    // _getCurrentLocation();
    _setCustomMarkerIcons();
    super.initState();
  }

  Future<void> _setCustomMarkerIcons() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/map.png',
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();

    setState(
      () {
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            infoWindow: InfoWindow(title: 'My Location'),
            icon: markerIcon ?? BitmapDescriptor.defaultMarkerWithHue(1),
          ),
        );
        _circles.add(
          Circle(
            circleId: CircleId('0'),
            center:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            radius: 25,
            strokeColor: AppColors.greenIcon.withOpacity(0),
            fillColor: AppColors.greenIcon.withOpacity(0.1),
          ),
        );
        _circles.add(
          Circle(
            circleId: CircleId('1'),
            center:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            radius: 20,
            strokeColor: AppColors.greenIcon.withOpacity(0),
            fillColor: AppColors.greenIcon.withOpacity(0.15),
          ),
        );
        _circles.add(
          Circle(
            circleId: CircleId('2'),
            center:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            radius: 12,
            strokeColor: AppColors.greenIcon.withOpacity(0),
            fillColor: AppColors.greenIcon.withOpacity(0.25),
          ),
        );
        _circles.add(
          Circle(
            circleId: CircleId('3'),
            center:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            radius: 5,
            strokeColor: AppColors.greenIcon.withOpacity(0),
            fillColor: AppColors.greenIcon.withOpacity(0.5),
          ),
        );
      },
    );

    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_currentPosition!.latitude - 0.0002,
                _currentPosition!.longitude),
            zoom: 19),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          myLocationEnabled: true,
          markers: _markers,
          circles: _circles,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 155),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_outlined),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 54,
                        width: 172,
                        child: Button(
                          text: 'Rental',
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.location_searching_rounded),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 141,
                    width: 364,
                    // decoration: BoxDecoration(
                    //   color: AppColors.lightGreen100,
                    //   borderRadius: BorderRadius.circular(4),
                    //   border: Border.all(
                    //     color: AppColors.greenIcon,
                    //     width: 1,
                    //   ),
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 54,
                            child: TextField(
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.lightGreen,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon:
                                    const Icon(Icons.favorite_border_outlined),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.greenIcon,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.5,
                                    color: AppColors.greenIcon,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: 'Where would you go?',
                                hintStyle: TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 48,
                                width: 336,
                                decoration: BoxDecoration(
                                    color: AppColors.lightGreen,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.greenIcon, width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectText = true;
                                        });
                                      },
                                      child: SizedBox(
                                        width: 85,
                                        child: Text(
                                          'Transport',
                                          style: TextStyle(
                                            color: AppColors.darkGrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectText = false;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 85,
                                        child: Text(
                                          'Delivery',
                                          style: TextStyle(
                                            color: AppColors.darkGrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: selectText ? 0 : null,
                                right: selectText ? null : 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  width: 168,
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    selectText ? 'Transport' : 'Delivery',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
