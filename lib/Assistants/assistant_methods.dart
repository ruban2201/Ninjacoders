
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:usg_app_user/Assistants/request_assistant.dart';
import 'package:usg_app_user/global/global.dart';
import 'package:usg_app_user/global/map_key.dart';
import 'package:usg_app_user/models/directions.dart';
import 'package:usg_app_user/models/user_model.dart';

import '../infoHandler/app_info.dart';

class AssistantMethods {

  static void readCurrentOnlineUserInfo() async{
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentUser!.uid);

    userRef.once().then((snap) {
      if(snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicsCoordinates(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No Response."){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePicUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
}