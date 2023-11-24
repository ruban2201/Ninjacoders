
import 'package:flutter/cupertino.dart';
import 'package:usg_app_user/models/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  //List<String>historyTripKeysList = [];
  //List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePicUpLocationAddress(Directions userPickUpAddress){
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress){
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

}
