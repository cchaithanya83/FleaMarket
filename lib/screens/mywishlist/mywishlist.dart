import 'package:fleamarket/screens/editprofile.dart';
import 'package:fleamarket/screens/mywishlist/wishlistcard.dart';
import 'package:fleamarket/support/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        elevation: 0,
        backgroundColor: const Color(0XFFDEEFFD),
        actions: [
          IconButton(
            onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile(),));

            },
            icon: const Icon(Icons.account_circle_outlined),
          )
        ],
      ),
      drawer: myDrawer(context),
      backgroundColor: const Color(0XFFDEEFFD),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').doc(userId).collection('wishlist').snapshots(),
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
      
            var wishlistItems = snapshot.data!.docs;
      
            return ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                var wishlistItem = wishlistItems[index].data() as Map<String, dynamic>;
                var productRef = wishlistItem['productRef'] as DocumentReference<Map<String, dynamic>>;
                
                return FutureBuilder<Map<String, dynamic>>(
                  future: fetchDataWish(productRef),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
      
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
      
                    var productDetails = snapshot.data!;
                    return WishlistCard(product: productDetails);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchDataWish(DocumentReference<Map<String, dynamic>> productRef) async {
    try {
      var snapshot = await productRef.get();
      if (snapshot.exists) {
        var productDetails = snapshot.data()!;
        return productDetails;
      } else {
        // Handle the case where the document does not exist
        return {};
      }
    } catch (error) {
      print('Error fetching data: $error');
      return {};
    }
  }
}

