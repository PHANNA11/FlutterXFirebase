import 'dart:developer';

import 'package:appxfirebase/model/product_model.dart';
import 'package:appxfirebase/view/auth/screen/login_screen.dart';
import 'package:appxfirebase/view/shop/home_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../auth/firebase/firebase_auth_controller.dart';
import 'detail_product.dart';

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
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeShop(),
                      ));
                },
                leading: Icon(Icons.store),
                title: Text('SHOP'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ),
              Spacer(),
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
                  : ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return buildProductCard(
                            pro: ProductModel.fromMap(
                          map: snapshot.data!.docs[index].data()
                              as Map<String, dynamic>,
                        ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Colors.black54,
                        );
                      },
                    );
        },
      ),
    );
  }

  Widget buildProductCard({required ProductModel pro}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProduct(productModel: pro),
            ));
      },
      child: Container(
        //  margin: EdgeInsets.all(8),
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                maxRadius: 20,
                backgroundImage: NetworkImage(
                    'https://imgs.search.brave.com/dfwPXf5z9iiT2hGH2bFgi5wgPji80IhKqbly-nDYcBI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzQxLzM5LzA1/LzM2MF9GXzI0MTM5/MDU5M19MM2ZuRGlw/WGVsN2ozOERRS1dY/TFJ6cEdQdUdRMW1Z/RC5qcGc'),
              ),
              title: Text(pro.name!),
              subtitle: Text(DateTime.now().toString()),
              trailing: Icon(
                pro.favorite! ? Icons.favorite : Icons.favorite_border,
                color: pro.favorite! ? Colors.red : Colors.black,
              ),
            ),
            Hero(
              tag: pro.code!,
              child: Image(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(pro.image!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ${pro.price}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Colors:'),
                        CircleAvatar(
                          maxRadius: 8,
                          backgroundColor: HexColor(pro.backgroundColor!),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.shopping_cart)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
