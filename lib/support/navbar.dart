import 'package:fleamarket/screens/mywishlist/mywishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fleamarket/screens/homescreen.dart';
import 'package:fleamarket/screens/login.dart';
import 'package:fleamarket/screens/myads/myads.dart';

Widget myDrawer(BuildContext context) {

  return Drawer(


    child: ListView(
      children: [        
        UserAccountsDrawerHeader(
          accountName: Text(getname()),
          accountEmail: Text(getemail()),
          // currentAccountPicture: CircleAvatar(
          //   child: Icon(Icons.person),
          // ),
        ),
        
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text(' Home '),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));            
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text(' My Ads '),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAdsScreen(),));
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text(' My Wishlist '),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Wishlist(),));
          },
        ),
        
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('LogOut'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
          },
        ),
      ],
    ),
  );
}
String getname(){
  String name=FirebaseAuth.instance.currentUser!.displayName.toString();
  return name;
}
String getemail(){
  String email=FirebaseAuth.instance.currentUser!.email.toString();
  return(email);
}