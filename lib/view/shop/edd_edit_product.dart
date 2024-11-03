import 'dart:io';

import 'package:appxfirebase/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/form_widget.dart';
import '../auth/firebase/firebase_firestor_con.dart';

class AddEditProduct extends StatefulWidget {
  AddEditProduct({
    super.key,
    this.pro,
    this.docId,
  });
  ProductModel? pro;
  String? docId;

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController descController = TextEditingController();
  File? fileImage;
  void setInitData() {
    setState(() {
      nameController.text = widget.pro!.name!;
      codeController.text = widget.pro!.code!;
      sizeController.text = widget.pro!.size!.toString();
      priceController.text = widget.pro!.price!.toString();
      imageController.text = widget.pro!.image!;
      descController.text = widget.pro!.description!;
    });
  }

  void clear() {
    setState(() {
      nameController.text = codeController.text = sizeController.text =
          priceController.text =
              imageController.text = descController.text = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.pro == null) {
      clear();
    } else {
      setInitData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShopWidget().buildForm(
                controller: nameController,
                hintText: 'Enter Name',
                isRequired: true),
            ShopWidget()
                .buildForm(controller: codeController, hintText: 'Enter Code'),

            ShopWidget()
                .buildForm(controller: sizeController, hintText: 'Enter Size'),
            ShopWidget().buildForm(
                controller: priceController, hintText: 'Enter Price'),
            GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            openCameraAndGallary(
                                imageSource: ImageSource.camera);
                          },
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                        ),
                        ListTile(
                          onTap: () async {
                            openCameraAndGallary(
                                imageSource: ImageSource.gallery);
                          },
                          leading: const Icon(Icons.image),
                          title: const Text('Gallay'),
                        )
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    image: fileImage == null
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(fileImage!.path)))),
                child: fileImage == null
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)),
                          child: const Center(
                            child: Icon(
                              Icons.image_rounded,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            ShopWidget().buildForm(
                controller: imageController,
                hintText: 'Enter Image Link',
                isRequired: true),

            ShopWidget().buildForm(
                controller: descController, hintText: 'Detail product'),
            if (imageController.text.isNotEmpty)
              Image(
                  height: 200,
                  width: double.infinity,
                  image: NetworkImage(imageController.text))
            //  ShopWidget().buildForm(controller: nameController),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            widget.pro == null
                ? await CloudFirebaseController()
                    .addProduct(
                        pro: ProductModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: nameController.text,
                            code: codeController.text,
                            price: double.parse(priceController.text),
                            image: imageController.text,
                            description: descController.text,
                            backgroundColor: '#CBD7CE',
                            favorite: false,
                            qty: 0,
                            varriants: ['#008000', '#6F7D6F', '#CBD7CE']))
                    .whenComplete(() {
                    Navigator.pop(context);
                  })
                : await CloudFirebaseController()
                    .updateProduct(
                        docId: widget.docId.toString(),
                        pro: ProductModel(
                            id: widget.pro!.id.toString(),
                            name: nameController.text,
                            code: codeController.text,
                            price: double.parse(priceController.text),
                            image: imageController.text,
                            description: descController.text,
                            backgroundColor: '#CBD CE',
                            favorite: false,
                            qty: 0,
                            varriants: ['#008000', '#6F7D6F', '#CBD7CE']))
                    .whenComplete(() {
                    Navigator.pop(context);
                  });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent),
            child: Center(
              child: Text('Save'),
            ),
          ),
        ),
      ),
    );
  }

  void openCameraAndGallary({ImageSource? imageSource}) async {
    var image = await ImagePicker()
        .pickImage(source: imageSource ?? ImageSource.gallery);
    setState(() {
      fileImage = File(image!.path);
    });
    uploadImage();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  bool isLoading = false;
  final storageRef = FirebaseStorage.instance.ref();
  void uploadImage() async {
    var imagePath = storageRef
        .child('/images/products')
        .child('/${DateTime.now().microsecondsSinceEpoch}.png');

    try {
      await imagePath.putFile(File(fileImage!.path));
      await imagePath.getDownloadURL().then((value) {
        setState(() {
          imageController.text = value;
        });
      });
    } on FirebaseException catch (e) {
      // ...
    }
  }
}
