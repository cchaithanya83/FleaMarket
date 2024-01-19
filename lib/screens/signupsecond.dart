import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleamarket/support/loadingscreen.dart';
import 'package:fleamarket/support/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleamarket/screens/login.dart';

class SignUpSecond extends StatefulWidget {
  final String email, name;
  const SignUpSecond({super.key, required this.email, required this.name});

  @override
  State<SignUpSecond> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpSecond> {
  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final collegeController = TextEditingController();
    final passwordController = TextEditingController();
    final conffirmPasswordController = TextEditingController();
    String uid = '';

    return Scaffold(
        appBar: null,
        backgroundColor: const Color(0xFFDEEFFD),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 40,
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
              height: 40,
            ),
            Image.asset('images/FleaMarket.png'),
            const SizedBox(height: 10),
            Image.asset('images/A Campus Marketplace.png'),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(
                            color: Color(0xFF28353A),
                            width: 273.0,
                          )),
                      labelText: 'Enter Your Phone Number',
                      filled: true,
                      iconColor: Colors.black,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: collegeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(
                            color: Color(0xFF28353A),
                            width: 273.0,
                          )),
                      labelText: 'Enter Your College',
                      filled: true,
                      iconColor: Colors.black,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
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
                  const SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    controller: conffirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(
                            color: Color(0xFF28353A),
                            width: 273.0,
                          )),
                      labelText: 'Confirm Your Password',
                      filled: true,
                      iconColor: Colors.black,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
                onPressed: () async {
                  String phone = phoneController.text;
                  String college = collegeController.text;
                  String password = passwordController.text;
                  String confirmpassword = conffirmPasswordController.text;

                  if (password == confirmpassword) {
                    try {
                      showLoaderDialog(context);
                      print(password);
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: widget.email, password: password);
                      print('done2');
                      userCredential.user!.updateDisplayName(widget.name);
                      uid = userCredential.user!.uid;
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      await firestore.collection('Users').doc(uid).set({
                        'email': widget.email,
                        'phone': phone,
                        'name': widget.name,
                        'college': college,
                        'uid': uid,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SignUp Successfull'),
        ),
      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        showmessage('The password provided is too weak.');
                        Navigator.pop(context);
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      showmessage('The account already exists for that email.');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print(e);
                      showmessage('$e');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Password and confirm Password doesnot match'),
                      ),
                    );
                  }
                },
                child: const Text("SignUp")),
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
