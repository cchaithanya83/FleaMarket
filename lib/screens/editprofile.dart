import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleamarket/support/loadingscreen.dart';
import 'package:fleamarket/support/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}
    final phoneController =TextEditingController();
    final collegeController =TextEditingController();
    final NameController =TextEditingController();
    final emailController =TextEditingController();

class _EditProfileState extends State<EditProfile> {
      @override
  void initState() {
    super.initState();   
    fetchUserDetails();  
  }
    Future<void> fetchUserDetails() async {
      const Center(
              child: CircularProgressIndicator(),
            );
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('Users').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
        setState(() {
          NameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          collegeController.text = userData['college'] ?? '';
          emailController.text = userData['email'] ?? '';

        });
      }
    } catch (error) {
      showmessage('Error fetching user details');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error fetching user details')));
      // print('Error fetching user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    String uid=FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color(0xFFDEEFFD),
        leading: BackButton(), 
        title: Text('Edit Profile'),
      ),
        backgroundColor: const Color(0xFFDEEFFD),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 30,
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
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(
                            color: Color(0xFF28353A),
                            width: 273.0,
                          )),
                      labelText: 'Enter your email',
                      enabled: false,
                      filled: true,
                      iconColor: Colors.black,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                    TextField(
                    controller: NameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(
                            color: Color(0xFF28353A),
                            width: 273.0,
                          )),
                      labelText: 'Enter your Name',
                      filled: true,
                      iconColor: Colors.black,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16.0),
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

                  
                ],
              ),
            ),
            FilledButton(onPressed: () async{
              
              String phone= phoneController.text;
              String college = collegeController.text;
              String name = NameController.text;              
              // String email = emailController.text;
              if (phone.isEmpty || !isValidPhoneNumber(phone) ) {
      showErrorMessage("Invalid phone number");
      return;
    }
     if (name.isEmpty || !isValidName(name) ) {
      showErrorMessage("Invalid name");
      return;
    }              
                 

                     FirebaseFirestore firestore = FirebaseFirestore.instance;
                     try{
                            showLoaderDialog(context);

                     await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
                     await firestore.collection('Users').doc(uid).update({
                      // 'email':email,
                      'phone':phone,
                      'name':name,
                      'college':college,
                      'uid':uid,
                      
                    });
                     }
                     catch(e){
                      // print(e);
                     }
                     
                 Fluttertoast.showToast(
                      msg: "Updated Sucessfully",
                      toastLength: Toast.LENGTH_SHORT,
                 );
                 Navigator.pop(context);
                 Navigator.pop(context);
 


                  }
                  ,child: const Text('Update'),
            )
                    

          
          ]),
        )));
  }
}

bool isValidPhoneNumber(String phone) {
  return RegExp(r'^[0-9]+$').hasMatch(phone);
}

bool isValidName(String name) {
  return name.length >= 3;
}

void showErrorMessage(String message) {
  Fluttertoast.showToast(
                      msg: message,
                      toastLength: Toast.LENGTH_SHORT,
                 );
}

