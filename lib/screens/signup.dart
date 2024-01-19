import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleamarket/screens/homescreen.dart';
import 'package:fleamarket/screens/socialsignin.dart';
import 'package:fleamarket/support/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fleamarket/screens/login.dart';
import 'package:fleamarket/screens/signupsecond.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final nameController=TextEditingController();
    final emailController=TextEditingController();
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
              height: 60,
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
                    
                   controller: nameController, 
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(
                            color: Color(0xFF28353A),
                            width: 273.0,
                          )),
                      labelText: 'Enter  Your Name',
                      filled: true,
                      iconColor: Colors.black,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
                onPressed: () {
                  String name=nameController.text;
                  String email=emailController.text;
                  if(!(name.length<4 || email.length<8)){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  SignUpSecond(email: email, name: name),
                      ));
                  }
                  else{
                    showmessage('Enter vaild email or name');
                  }
                },
                child: const Text("Next >")),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Or SignUp With',
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
                const Text('Already a User!'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: const Text("Login"))
              ],
            )
          ]),
        )));
  }
}
