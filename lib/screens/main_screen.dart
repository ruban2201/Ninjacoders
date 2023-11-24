import 'dart:async';

import'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:usg_app_user/Assistants/assistant_methods.dart';
import 'package:usg_app_user/global/global.dart';
import 'package:usg_app_user/global/map_key.dart';

import '../infoHandler/app_info.dart';
import '../models/directions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  get darkTheme => null;

  locateUserPosition() async {
    Position cPostion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPostion;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicsCoordinates(userCurrentPosition!, context);
    print("This is our address = " + humanReadableAddress);

    userName =  userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    //initializeGeoFireListener();
    //
    //AssistantMethods.readTipsKeysForOnlineUser(context);

  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey
      );
      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false).updatePicUpLocationAddress(userPickUpAddress);

        //_address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if(
    _locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLocationPermissionAllowed();
  }


  @override
  Widget build(BuildContext context) {
    var provider;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: _kGooglePlex,
                polylines: polylineSet,
                markers: markersSet,
                circles: circlesSet,
                onMapCreated: (GoogleMapController controller){
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;

                  setState(() {

                  });

                  locateUserPosition();
              },
              onCameraMove: (CameraPosition? position){
                  if(pickLocation != position!.target){
                    setState(() {
                      pickLocation = position.target;
                    });
                  }
              },
              onCameraIdle: () {
                  getAddressFromLatLng();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.asset("images/pick.png",height: 45, width: 45,),
              ),
            ),

            // ui for searching location
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkTheme ? Colors.black: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children:[
                          Container(
                            decoration: BoxDecoration(
                                color: darkTheme ? Colors.grey.shade900: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                            ),

                           child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color:darkTheme ? Colors.amber.shade400 : Colors.blue,),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("From",
                                          style: TextStyle(
                                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                            fontSize:12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          ),
                                          Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                                              ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "...."
                                              : "Not Getting Address",
                                            style: TextStyle(color: Colors.grey, fontSize: 14),
                                          )

                                        ],
                                      )
                                    ],
                                  ),
                           ),

                            SizedBox(height: 5,),

                            Divider(
                              height: 1,
                              thickness: 2,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                          ),

                            SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () {

                                    },
                                    child:Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color:darkTheme ? Colors.amber.shade400 : Colors.blue,),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("To",
                                              style: TextStyle(
                                                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                                fontSize:12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(Provider.of<AppInfo>(context).userDropOffLocation != null
                                                ? (Provider.of<AppInfo>(context).userDropOffLocation!.locationName!).substring(0, 24) + "...."
                                                : "Where to?",
                                              style: TextStyle(color: Colors.grey, fontSize: 14),
                                            )

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                          ),
                          ),
                        ],
                      ),

                    ),
                  ],
                )


            ),
            ),

            // Positioned(
           // top: 40,
           // right: 20,
           // left: 20,
           // child: Container(
           //   decoration: BoxDecoration(
           //     border: Border.all(color: Colors.black),
           //       color: Colors.white,
           //   ),
           //     padding: EdgeInsets.all(20),
           //     child: Text(
           //       Provider.of<AppInfo> (context).userPickUpLocation != null
           //           ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24) + "...."
           //           : "Not Getting Address",
           //       overflow: TextOverflow.visible, softWrap: true,
           //     ),
           //   ),
           // ),

          ],
        ),
      ),
    );
  }
}