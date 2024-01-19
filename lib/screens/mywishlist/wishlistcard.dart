import 'package:fleamarket/screens/homesscreen2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
class WishlistCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const WishlistCard({Key? key, required this.product}) : super(key: key);

  @override
  State<WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        color: const Color.fromARGB(255, 255, 254, 254),
        child: Column(children: [
          TextButton(
            onPressed: () {
             Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  HomeScreen2(product :widget.product),
                  ));
            },
            
            child: Stack(
              children: [
                Image(
                  image: NetworkImage(widget.product['imageUrl']),
                  height: 197,
                  width: 340,
                ),
                
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '₹' + widget.product['price'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    widget.product['name'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0.10,
                    ),
                  ),
                ),
              ],
            ), 
            IconButton(onPressed: () {
              try{
                String userId = FirebaseAuth.instance.currentUser!.uid;
                
                 FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .collection('wishlist')
                    .doc(widget.product['productid']).delete();

               
                }
                catch(e){
                  print(e);
                }
                
  Fluttertoast.showToast(
                      msg: 'delete Succesfully',
                      toastLength: Toast.LENGTH_SHORT,
                 );
                setState(() {
                  
                });
                
                            
            }, icon: const Icon(Icons.delete))        
          ]
            ),
            
          ]),
        
        );
        
  }
}