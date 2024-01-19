import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:fleamarket/screens/chat.dart';

class HomeScreen2 extends StatelessWidget {
  final Map<String, dynamic> product;

  const HomeScreen2({required this.product, Key? key}) : super(key: key);

 

  Widget details(String title, String value) {
    
    return Table(
      
      textDirection: TextDirection.ltr,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 22.0),
                  child: Text(
                    title,
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 0.10,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 22.0),
                  child: Text(
                    value,
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 0.10,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Repeat similar structure for other rows
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xFFDEEFFD),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: [
            Row(
              children: [
                BackButton(
                    onPressed: () => Navigator.pop(context),
                    color: Colors.black,
                    style: const ButtonStyle(
                      iconSize: MaterialStatePropertyAll(30),
                    )),
              ],
            ),
            Container(
              // width: double.infinity,
              height: 207,
              decoration:  BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(product['imageUrl']),
                fit: BoxFit.fitHeight,
              )),
            ),
            Container(
              // margin: EdgeInsets.symmetric(vertical: 1.0),
              padding: const EdgeInsets.only(top: 16.00, left: 16.0),
              width: double.infinity,
              height: 94,
              decoration: const ShapeDecoration(
                color: Color(0xFFE2F2FF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFF607D8B)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    '₹'+product['price'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                    ),
                  )),
                  Expanded(
                      child: Text(
                    product['name'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                    ),
                  )),
                  Expanded(
                      child: Text(
                    product['personName'],
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                    ),
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: double.infinity,
              height: 171,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(222, 239, 253, 1),
                border: Border.symmetric(
                  // horizontal: BorderSide(color: Color(0xFF607D8B)),
                  horizontal: BorderSide(width: 1.00, color: Color(0xFF607D8B)),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 2,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 15.0),
                    child: Text(
                      'Details',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 0.10,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  details('Brand', product['brand']),
                  details('Author', product['author']),
                  details('Age', product['age']),
                  details('Condition', product['condition']),
                  details('Availability', product['availability'])
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: double.infinity,
              // height: 171,
              decoration: const BoxDecoration(
                color: Color(0xFFDEEFFD),
                border: Border.symmetric(
                  // horizontal: BorderSide(color: Color(0xFF607D8B)),
                  horizontal: BorderSide(width: 1.00, color: Color(0xFF607D8B)),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 2,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 15.0),
                    child: Text(
                      'Description',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 0.10,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 10.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        product['description'],
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: -0.28,
                        ),
                      )),
                ],
              ),
            )
          ]),
        ),
      ),


      bottomNavigationBar: NavigationBar(destinations: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: FilledButton(
              onPressed: () {
                String currentUid =FirebaseAuth.instance.currentUser!.uid;
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(currentUid: currentUid, uid: product['uid'], productid: product['productid'],name: product['personName'],) ,));
              },
              style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(Color(0xFF35454C)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chat ', style: TextStyle(fontSize: 18)),
                  Icon(
                    Icons.chat_bubble_rounded,
                    size: 24,
                  )
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: FilledButton(
              onPressed: () async {
                try{
                String userId = FirebaseAuth.instance.currentUser!.uid;
                DocumentReference productRef = FirebaseFirestore.instance
                    .collection('productlist')
                    .doc(product['productid']);
                DocumentReference wishlistRef = FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .collection('wishlist')
                    .doc(product['productid']);

                await wishlistRef.set({'productRef': productRef});
                }
                catch(e){
                  print(e);
                }
                
  Fluttertoast.showToast(
                      msg: 'Added Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                 );

              },
              style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(Color(0xFF35454C)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Wishlist ', style: TextStyle(fontSize: 18)),
                  Icon(
                    Icons.favorite,
                    size: 24,
                  )
                ],
              )),
        ),
      ], backgroundColor: const Color(0xFFDEEFFD)),
    );
  }
}
