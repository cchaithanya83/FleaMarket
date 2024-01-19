import 'package:fleamarket/screens/myads/editads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fleamarket/screens/myads/mychatlist.dart';

class MyProductList extends StatelessWidget {
  const MyProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final String myuid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color(0XFFDEEFFD),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('productlist')
            .where('uid', isEqualTo: myuid)
            .snapshots(),
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

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
                    builder: (context) => MyChatList(product: widget.product),
                  ));
            },
            
            child: Stack(
              children: [
                Image(
                  image: NetworkImage(widget.product['imageUrl']),
                  height: 197,
                  width: 340,
                ),
                if (widget.product['status']=='closed')
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Text(
                          'Sold',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
            PopupMenuButton(
              
              itemBuilder: (context) {
                String buttonText = widget.product['status'] == 'closed' ? 'Mark as Unsold' : 'Mark as Sold';
                IconData buttonIcon = widget.product['status'] == 'closed' ? Icons.close : Icons.check;
                return [
                  PopupMenuItem(
                    child: Container(
                      child:TextButton(child: Row(
                        children: [
                          Icon(Icons.edit),
                          Text("Edit"),
                        ],
                      ),onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) =>EditProduct(existingProduct: widget.product,),)             
                      ),
                
                    ))),
                    
                  PopupMenuItem(
                    
                    child: Container(
                      child: TextButton(child: Row(
                        children: [
                          Icon(buttonIcon),
                          Text(buttonText),
                        ],
                      ),onPressed: ()   async{
                         String newStatus = widget.product['status'] == 'closed' ? 'open' : 'closed';
                          await FirebaseFirestore.instance
                                .collection('productlist')
                                .doc(widget.product['productid'])
                                .update({'status':newStatus});
                          Message("Update successfully");
                                
                          setState(() {                            
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: Container(
                      child: TextButton(child:const Row(
                        children: [
                          Icon(Icons.delete),
                          Text("Delete"),
                        ],
                      ),onPressed: ()    async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('productlist')
                                .doc(widget.product['productid'])
                                .delete();
                                Message("Deleted Sucessfully");
                            print('Deleted successfully');
                          } catch (error) {
                            print('Delete failed: $error');
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  ];
                  }
                  ),
                ])]));
              }
}

void Message(String message) {
  Fluttertoast.showToast(
                      msg: message,
                      toastLength: Toast.LENGTH_SHORT,
                 );
}