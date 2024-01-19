import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fleamarket/support/fetchdata.dart';
import 'package:fleamarket/support/loadingscreen.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddProduct1 extends StatefulWidget {
  const AddProduct1({Key? key}) : super(key: key);

  @override
  State<AddProduct1> createState() => _AddProduct1State();
}

class _AddProduct1State extends State<AddProduct1> {
  String imgurl = 'nothing';
  XFile? file;
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  late SingleValueDropDownController availabilityControl=SingleValueDropDownController();
  

  TextEditingController condtionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    img() {
      if (imgurl == 'nothing') {
        // print("nothig");

        return const Center(child: Text("Upload image"));
      } else {
        return Image.network(imgurl);
      }
    }

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
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFDEEFFD),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        boxShadow: [
                          BoxShadow(blurStyle: BlurStyle.outer, blurRadius: 2)
                        ]),
                    width: 180,
                    height: 100,
                    child: img())),
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
                    labelText: 'Product Age',
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
            Container(
              margin: EdgeInsets.only(left: 7, right: 7,top: 4,bottom: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),border: Border.all(color: Color.fromARGB(255, 156, 150, 150))),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropDownTextField(      
                    searchDecoration: InputDecoration.collapsed(hintText: 'Choose availability'),                                                
                    controller: availabilityControl.setDropDown(const DropDownValueModel(name: 'Choose availability', value: 'choose')),
                    dropDownList: const [
                      DropDownValueModel(name: 'Immediately', value: 'Immediately'),
                      DropDownValueModel(name: '1 Week', value: '1 Week'),
                      DropDownValueModel(name: '2 Week', value: '2 Week'),
                      DropDownValueModel(name: '1 Month', value: '1 Month'),
                    ],
                    onChanged: (val) {},
                    
                  )),
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
                    if(availabilityControl.dropDownValue!.value){
                      showErrorMessage("Choose availability");
                      return;
                    }
                    Product product = Product(
                      name: nameController.text,
                      price: priceController.text,
                      brand: brandController.text,
                      author: authorController.text,
                      model: modelController.text,
                      age: ageController.text,
                      condition: condtionController.text,
                      availability: availabilityControl.dropDownValue!.value,
                      description: descriptionController.text,
                      imageUrl: imgurl,
                    );
                    
                    if (priceController.text.isEmpty ||
                        !isValidprice(priceController.text)) {
                      showErrorMessage("Invalid price");
                      return;
                    }
                    if (nameController.text.isEmpty ||
                        !isValidName(nameController.text)) {
                      showErrorMessage("Invalid name");
                      return;
                    }
                    if (imgurl.isEmpty || !isValidName(imgurl)) {
                      showErrorMessage("Upload picture");
                      return;
                    }

                    uploadProductToFirestore(product);
                  },
                  child: const Text('Submit')),
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
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String? personname = FirebaseAuth.instance.currentUser!.displayName;
      CollectionReference productIds = firestore.collection('productid');
      DocumentSnapshot productid = await productIds.doc('productid').get();
      int currentProductId = productid['productid'];
      int newProductId = currentProductId + 1;

      await firestore
          .collection('productlist')
          .doc(newProductId.toString())
          .set({
        'name': product.name,
        'price': product.price,
        'author': product.author,
        'brand': product.brand,
        'model': product.model,
        'age': product.age,
        'condition': product.condition,
        'availability': product.availability,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'productid': newProductId.toString(),
        'uid': uid,
        'personName': personname,
        'status': 'open',
      });

      print('Product details uploaded to Firestore successfully!');
      await productIds.doc('productid').update({'productid': newProductId});
      Navigator.pop(context);
    } catch (error) {
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
                    file = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    handleFileSelection();
                  },
                  child: const Text('Camera'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close the dialog
                    file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
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

bool isValidprice(String phone) {
  return RegExp(r'^[0-9]+$').hasMatch(phone);
}

bool isValidName(String name) {
  return name.length >= 3;
}

void showErrorMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
  );
}
