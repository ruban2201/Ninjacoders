import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usg_app_drivers/global/global.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
  Future<void> showDriverNameDialogAlert(BuildContext context, String name){

    nameTextEditingController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancle", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "Address": addressTextEditingController.text.trim(),
                  }).then((value) {
                    addressTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Sucessfully.\n reload the app to see the changes");
                  }).catchError((errorMessage){
                    Fluttertoast.showToast(msg: "Error Occurred.\n $errorMessage");
                  });

                  Navigator.pop(context);
                },

                child: Text("OK", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }


  }



  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: darkTheme ? Colors.amber.shade400 : Colors.black,
            )
          ),
          title: Text("Profile Screen", style: TextStyle(color: darkTheme ? Colors.amber.shade400 : Colors.black, fontWeight:FontWeight.bold ),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
             Center(
               child: Padding(
                 padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                 child: Column(
                   children: [
                     Container(
                       padding: EdgeInsets.all(50),
                       decoration: BoxDecoration(
                         color: darkTheme ? Colors.amber.shade400 : Colors.lightBlue,
                         shape: BoxShape.circle,
                       ),
                     child: Icon(Icons.person, color: darkTheme ? Colors.black : Colors.white,),
                       ),

                     SizedBox(height: 30,),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("${onlineDriverData.name}",
                             style: TextStyle(
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                         ),
                         ),
                         IconButton(
                           onPressed: () {
                             showDriverNameDialogAlert(context, onlineDriverData.name!);
                           },
                           icon: Icon(
                             Icons.edit,
                             color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                           ),
                         )
                       ],
                     )

                 ],
                 ),
               ),
             ),
          ],
        )
      ),

    );
  }
}

