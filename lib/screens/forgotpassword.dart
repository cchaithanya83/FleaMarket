import 'package:fleamarket/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleamarket/support/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {


  final emailController = TextEditingController();

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
                  
                ],
              ),
            ),
            FilledButton(
                onPressed: () async {
                  try {
      String email = emailController.text.trim();

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent to $email'),
        
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      showmessage('Error: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error: $e'),
      //   ),
      // );
    }
                  
                },
                child: const Text("Send Link")
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
                    onPressed: () {},
                    child: Image.asset('images/google_icon.png')),
                TextButton(
                    onPressed: () {},
                    child: Image.asset('images/facebook_icon.png'))
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
        )));
  }
}
