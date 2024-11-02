import 'package:appxfirebase/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}
