import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fleamarket/screens/forgotpassword.dart';
import 'package:fleamarket/screens/homescreen.dart';
import 'package:fleamarket/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleamarket/screens/socialsignin.dart';
import 'package:fleamarket/support/loadingscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void loginsuccess(String uid) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: const Color(0xFFDEEFFD),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            // applogoL5X (41:195)
            width: 72,
            height: 80.44,
            child: Image.asset(
              'images/app_logo.png',
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Image.asset('images/FleaMarket.png'),
          const SizedBox(height: 10),
          Image.asset('images/A Campus Marketplace.png'),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(
                          color: Color(0xFF28353A),
                          width: 273.0,
                        )),
                    labelText: 'Enter Your Email',
                    filled: true,
                    iconColor: Colors.black,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(
                          color: Color(0xFF28353A),
                          width: 273.0,
                        )),
                    labelText: 'Enter Password',
                    filled: true,
                    iconColor: Colors.black,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {
                         
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>const ForgotPasswordScreen() ,));
                    }, child: const Text("Forgot Password!"))                      
                  ],
                ),
              ],
            ),
          ),
          FilledButton(
              onPressed: () async {
                try { 
                  showLoaderDialog(context);             
        
                  final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
        
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  String? token = await FirebaseMessaging.instance.getToken();
                  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({'fmctoken' : token});
        
                  loginsuccess(credential.user!.uid);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
          msg: 'No user found for that email.',
          toastLength: Toast.LENGTH_SHORT,
              
            );
                 
                    // print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
          msg: 'Wrong password provided',
          toastLength: Toast.LENGTH_SHORT,
              
            );
                    
                    print('Wrong password provided for that user.');
                  }
                  else{
                    Navigator.pop(context);
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Error: $e'),
              //   ),
              // );
              Fluttertoast.showToast(
          msg: 'Wrong password provided',
          toastLength: Toast.LENGTH_SHORT,
              
            );
                  }
                }
              },
              child: const Text("Login")
              ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Or Login With',
              style: GoogleFonts.raleway(
                color: const Color(0xFF607D8B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 0.11,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
               final result = await signInWithGoogle();
              print(result);
              print(result.user?.email);
              DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance.collection('Users').doc(result.user!.uid).get();
        
              if (userSnapshot.exists) {  
                 String? token = await FirebaseMessaging.instance.getToken();
                  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({'fmctoken' : token});
          Navigator.push(context, MaterialPageRoute(builder: (context) =>   const HomeScreen()
          ));
              } 
              else{
          Navigator.push(context, MaterialPageRoute(builder: (context) =>   const SocialProfile()));
          
              }      
              },
                  child: Image.asset('images/google_icon.png')),
              // TextButton(
              //     onPressed: () {},
              //     child: Image.asset('images/facebook_icon.png'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not a User!'),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ));
                  },
                  child: const Text("SignUp"))
            ],
          )
            ]),
          ),
        ));
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
