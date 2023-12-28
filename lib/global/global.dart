
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usg_app_user/models/direction_details_info.dart';

import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

String cloudMessagingServerToken = "key=AAAAv1NhuE4:APA91bHj7-VlInvglYtHJEKrOtk_wsplf0RsqzpFcmM8FDimFR6DqS9DJnGZMHoYvcfldnl9F3Sgfx8R5LeRNhd-OH3cJTKLLx3H8QlCOEvshck8QaUGmx11rP__sV5vQ-xKD7IMMs8T";
List driversList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";

double countRatingStars = 0.0;
String titleStarsRating = "";