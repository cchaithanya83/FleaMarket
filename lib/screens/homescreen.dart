import 'package:fleamarket/screens/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:fleamarket/screens/addproduct1.dart';
import 'package:fleamarket/screens/productcard.dart';
import 'package:fleamarket/support/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key}) : super(key: key);
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0XFFDEEFFD),
      appBar: AppBar(
          title: Image.asset('images/FleaMarketTop.png'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0XFFDEEFFD),
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
      body: const Padding(
        padding: EdgeInsets.all(15),
        child: ProductList(),
      ),
    );
  }
}
