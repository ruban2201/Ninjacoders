import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usg_app_user/screens/forgot_password_screen.dart';
import 'package:usg_app_user/screens/register_screen.dart';

import '../global/global.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    // validate all the form fields
    if(_formKey.currentState!.validate()) {
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        await Fluttertoast.showToast(msg: "Successfully Logged In");
        Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error Occured: \n $errorMessage");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all fields are valid");
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
        body: ListView (
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/dark1.jpg' : 'images/light1.jpg'),

                const SizedBox(height: 20,),

                Text(
                  'Login',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
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
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Email",
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
                                  return 'Email can\'t be empty';
                                }
                                if(EmailValidator.validate(text) == true){
                                  return null;
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid email" ;
                                }
                                if(text.length > 49) {
                                  return "Email can't be more than 100";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                emailTextEditingController.text = text;
                              }),
                            ),

                            const SizedBox(height: 20,),

                            TextFormField(
                              obscureText: !_passwordVisible,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                  hintText: "Password",
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                    ),
                                    onPressed: () {
                                      //update the state i.e toggle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  )
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Password can\'t be empty';
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid password" ;
                                }
                                if(text.length > 49) {
                                  return "Password can't be more than 50";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                passwordTextEditingController.text = text;
                              }),
                            ),

                            const SizedBox(height: 20,),

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
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                            ),

                            const SizedBox(height: 20,),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c) => const ForgotPasswordScreen()));
                              },
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
                                  "Doesn't have an account ?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(width: 5,),

                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen()));
                                    },
                                    child: Text(
                                      "Register",
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
