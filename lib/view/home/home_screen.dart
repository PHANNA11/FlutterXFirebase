import 'dart:developer';

import 'package:appxfirebase/model/product_model.dart';
import 'package:appxfirebase/view/auth/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/firebase/firebase_auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference productRef =
      FirebaseFirestore.instance.collection('Products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              color: Colors.blue,
              child: const Text('Log Out'),
              onPressed: () async {
                await FirebaseAuthController().logOut().then((value) {
                  if (value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  }
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productRef.snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasError
              ? const Center(
                  child: Icon(
                    Icons.info,
                    color: Colors.red,
                  ),
                )
              : snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        ProductModel product = ProductModel.fromFireBase(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(product.image.toString()),
                          ),
                          title: Text(product.name.toString()),
                        );
                      },
                    );
        },
      ),
    );
  }
}
