import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usg_app_drivers/splashScreen/splash_screen.dart';
import '../global/global.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();
  final carColorTextEditingController = TextEditingController();

  List<String> carTypes = ["Car", "CNG", "Bike"];
  String? selectedCarType;

  final _formKey = GlobalKey<FormState>();

  _submit() {
    if(_formKey.currentState!.validate()) {
      Map driverCarInfoMap = {
        "car_model": carModelTextEditingController.text.trim(),
        "car_number": carNumberTextEditingController.text.trim(),
        "car_color": carColorTextEditingController.text.trim(),
        "type": selectedCarType,

      };

      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
      userRef.child(currentUser!.uid).child("car_details").set(driverCarInfoMap);

      Fluttertoast.showToast(msg: "Car details has been saved. Congratulations");
      Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen())
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
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/dark1.jpg' : 'images/light1.jpg'),

                const SizedBox(height: 20,),

                Text(
                  "Add Car Details",
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Model",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name" ;
                                }
                                if(text.length > 49) {
                                  return "Name can't be more than 50";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                carModelTextEditingController.text = text;
                              }),
                            ),
                            const SizedBox(height: 20,),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Number",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name" ;
                                }
                                if(text.length > 49) {
                                  return "Name can't be more than 50";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                carNumberTextEditingController.text = text;
                              }),
                            ),
                            const SizedBox(height: 20,),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Car Color",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Name can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name" ;
                                }
                                if(text.length > 49) {
                                  return "Name can't be more than 50";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                carColorTextEditingController.text = text;
                              }),
                            ),
                            const SizedBox(height: 20,),

                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                    hintText: 'Please Select Your Car Type',
                                    prefixIcon: Icon(Icons.car_crash, color: darkTheme? Colors.amber.shade400 : Colors.grey),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,

                                        )
                                    )
                                ),
                                items: carTypes.map((car){
                                  return DropdownMenuItem(
                                    // ignore: sort_child_properties_last
                                    child: Text(
                                      car,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    value: car,
                                  );
                                }).toList(),
                                onChanged: (newValue){
                                  setState(() {
                                    selectedCarType = newValue.toString();
                                  });
                                }
                            ),

                            const SizedBox(height:20,),

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: darkTheme ? Colors.black : Colors.white, backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () {
                                  _submit();
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                            ),

                            const SizedBox(height: 20,),

                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Have an account ?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(width: 5,),

                                GestureDetector(
                                    onTap: () {
                                    },
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                      ),
                                    )
                                )
                              ],
                            )


                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
