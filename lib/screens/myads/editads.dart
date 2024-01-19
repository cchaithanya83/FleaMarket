import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fleamarket/support/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fleamarket/support/fetchdata.dart';
import 'package:fleamarket/support/loadingscreen.dart';



class EditProduct extends StatefulWidget {
   final Map<String, dynamic>? existingProduct;

  const EditProduct({Key? key, this.existingProduct}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String imgurl = "";
  XFile? file;
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController availabilityController = TextEditingController();
  TextEditingController condtionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
    @override
  void initState() {
    super.initState();

      nameController.text = widget.existingProduct!['name'];
      priceController.text = widget.existingProduct!['price'];
      brandController.text = widget.existingProduct!['brand'];
      authorController.text = widget.existingProduct!['author'];
      modelController.text = widget.existingProduct!['model'];
      ageController.text = widget.existingProduct!['age'];
      condtionController.text = widget.existingProduct!['condition'];
      availabilityController.text = widget.existingProduct!['availability'];
      descriptionController.text = widget.existingProduct!['description'];
      imgurl = widget.existingProduct!['imageUrl'];
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFDEEFFD),
      appBar: AppBar(
        title: Text('Include some details',
            style: GoogleFonts.inter(fontSize: 27)),
        leading: const BackButton(
            style: ButtonStyle(iconSize: MaterialStatePropertyAll(30))),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            TextButton(
                onPressed: () {
                  showOptionsDialog(context);
                },
                child: SizedBox(
                    width: 180, height: 100, child: Image.network(imgurl))),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name of product',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: priceController,
                decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: brandController,
                decoration: InputDecoration(
                    labelText: 'Brand',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: authorController,
                decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: modelController,
                decoration: InputDecoration(
                    labelText: 'Model (If applicable)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: condtionController,
                decoration: InputDecoration(
                    labelText: 'Condition',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: availabilityController,
                decoration: InputDecoration(
                    labelText: 'Availability',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                controller: descriptionController,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(

                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: FilledButton(
                  onPressed: () {
                    Product product = Product(
                      name: nameController.text,
                      price: priceController.text,
                      brand: brandController.text,
                      author: authorController.text,
                      model: modelController.text,
                      age: ageController.text,
                      condition: condtionController.text,
                      availability: availabilityController.text,
                      description: descriptionController.text,
                      imageUrl: imgurl,
                    );

                    uploadProductToFirestore(product);
                  },
                  child: const Text('Update')),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> uploadImageToFirebase(String filePath) async {
    
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference referenceImageToUpload = referenceDirImage.child(fileName);

    try {
      await referenceImageToUpload.putFile(File(filePath));
      String downloadUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        imgurl = downloadUrl;
      });

      print("Image uploaded successfully. URL: $imgurl");
    } catch (error) {
      print("Error uploading image: $error");
    }
    loading = false;
  }

  Future<void> uploadProductToFirestore(Product product) async {
    
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid =FirebaseAuth.instance.currentUser!.uid;
      String? personname = FirebaseAuth.instance.currentUser!.displayName;
      String id= widget.existingProduct!['productid'];      

      await firestore.collection('productlist').doc(id).update({        
        'name': product.name,
        'price': product.price,
        'author':product.author,
        'brand': product.brand,
        'model': product.model,
        'age': product.age,
        'condition': product.condition,
        'availability': product.availability,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'uid': uid,
        'personName' : personname,
        'status': 'open',
      });
      
      showmessage('Updated Sucessfully');

      print('Product details uploaded to Firestore successfully!');
      Navigator.pop(context);
      Navigator.pop(context);

    } catch (error) {
      showmessage('Error updating');

      print('Error uploading product details to Firestore: $error');
    }
  }



  void showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SizedBox(
            height: 120, // Adjust the height according to your preference
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close the dialog
                    file = await ImagePicker().pickImage(source: ImageSource.camera);
                    handleFileSelection();
                  },
                  child: const Text('Camera'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close the dialog
                    file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    handleFileSelection();
                  },
                  child: const Text('Gallery'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleFileSelection() async {
    showLoaderDialog(context);

    if (file != null) {
      await uploadImageToFirebase(file!.path);
      Navigator.pop(context); // Close the loader dialog
    } else {
      print("No image selected");
      Navigator.pop(context); // Close the loader dialog
    }
  }
}

class FilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const FilledButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
