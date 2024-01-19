import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fleamarket/screens/homesscreen2.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
              String myuid=FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0XFFDEEFFD),
      
      body: StreamBuilder<QuerySnapshot>(

      stream: FirebaseFirestore.instance.collection('productlist').where('uid', isNotEqualTo: myuid).where('status', isEqualTo: 'open').snapshots(),
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

          var products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index].data() as Map<String, dynamic>;
              return ProductCard(product: product);
              
              
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        color: const Color.fromARGB(255, 255, 254, 254),
        child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  HomeScreen2(product :product),
                  ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  
                  image: NetworkImage(product['imageUrl']),
                  height: 197,
                  width: 340,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '₹'+product['price'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    product['name'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0.10,
                    ),
                  ),
                ),
              ],
            )));
  }
}



