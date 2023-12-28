

import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:usg_app_drivers/global/global.dart';
import 'package:usg_app_drivers/global/user_ride_request_information.dart';

class PushNotificationSystem{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    //1. Terminated
    //When the app is closed and open directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
      if(remoteMessage != null) {
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"], context);
      }
    });

    //2.Foreground
    //When the app is open and receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });
  }

    readUserRideRequestInformation(String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance.ref().child("ALL Ride Request").child(userRideRequestId).child("driverId").onValue.listen((event) {
      if(event.snapshot.value == "waiting" || event.snapshot.value == firebaseAuth.currentUser!.uid){
        FirebaseDatabase.instance.ref().child("ALL Ride Request").child(userRideRequestId).once().then((snapData){
        if(snapData.snapshot.value != null){

          audioPlayer.open(Audio());
          audioPlayer.play();

          double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
          double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
          String originAddress = (snapData.snapshot.value! as Map)["originAddress"];

          double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
          double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
          String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];

          String userName = (snapData.snapshot.value! as Map)["userName"];
          String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

          String?  rideRequestId = snapData.snapshot.key;

          UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
          userRideRequestDetails.originLatLng = LatLng(originLat,originLng);
          userRideRequestDetails.originAddress = originAddress;
          userRideRequestDetails.destinationLatLng = LatLng(destinationLat, destinationLng);
          userRideRequestDetails.destinationAddress = destinationAddress;
          userRideRequestDetails.userName = userName;
          userRideRequestDetails.userPhone = userPhone;

          userRideRequestDetails.rideRequestId = rideRequestId;

          showDialog(
              context: context,
              builder: (BuildContext context) => NotificationDialogBox()
          );
        }
        else{
          Fluttertoast.showToast(msg: "This Ride Request Id do not exits");
        }
     });
   }
      else {
        Fluttertoast.showToast(msg: "This Ride Request has been cancelled");
        Navigator.pop(context);
      }
 });
 }
}