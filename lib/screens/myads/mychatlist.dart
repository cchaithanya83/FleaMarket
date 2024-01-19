import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fleamarket/screens/myads/mychat.dart';
class MyChatList extends StatelessWidget {
  final Map<String, dynamic> product;
  const MyChatList({required this.product,super.key});

  @override
  Widget build(BuildContext context) {
    print(product.toString());
    return Scaffold(
      backgroundColor: const Color(0xFFDEEFFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDEEFFD),
          title:  Text('Chat',style: GoogleFonts.inter(fontSize: 24)),
          elevation: 0,
          ),
          body: Padding(padding: const EdgeInsets.only(top: 20,left: 10,right: 10),child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productlist').doc(product['productid']).collection('message').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;
              return list(user['uid'],product['productid']);
              
            },
          );
        },
      ),),
    );
  }
  Widget list(String uid,String productid) {
  return FutureBuilder<String?>(
    future: fetchName(uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData) {
        return const Text('User not found');
      }

      String name = snapshot.data!;

      return TextButton(
        onPressed: () {
          String currentUid=FirebaseAuth.instance.currentUser!.uid;
          Navigator.push(context,MaterialPageRoute(builder: (context) => MyChatPage(currentUid: currentUid, uid: uid, productid: productid,name:name),));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => customchat(currentUid: currentUid, uid: uid, productid: productid,name: name),));
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFDEEFFD),
            border: Border(
              bottom: BorderSide(width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(5, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          height: 70,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                const Icon(
                  Icons.chat,
                  color: Color(0XFF000000),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 25,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<String?> fetchName(String uid) async {
  try {
    var snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (snapshot.exists) {
      String name = snapshot.get('name');
      return name;
    } else {
      return null; 
    }
  } catch (e) {
    print('Error fetching name: $e');
    return null;
  }
}
}