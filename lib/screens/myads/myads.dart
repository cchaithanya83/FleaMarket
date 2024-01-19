import 'package:fleamarket/screens/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fleamarket/screens/addproduct1.dart';
import 'package:fleamarket/screens/myads/myproductlist.dart';
import 'package:fleamarket/support/navbar.dart';
class MyAdsScreen extends StatefulWidget {


  const MyAdsScreen({ Key? key}) : super(key: key);
  

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFDEEFFD),
      appBar: AppBar(
          title:  Text('MyAds',style: GoogleFonts.inter(fontSize: 24)),
          elevation: 0,
          backgroundColor: Color(0XFFDEEFFD),
          actions: [
            IconButton(
              onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile(),));

              },
              icon: const Icon(Icons.account_circle_outlined),
            )
          ]),
      drawer: myDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProduct1(),));
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(15),
        child: MyProductList(),
      ),
    );
  }
}