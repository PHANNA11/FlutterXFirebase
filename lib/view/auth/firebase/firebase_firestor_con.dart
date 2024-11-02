import 'package:appxfirebase/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirebaseController {
  CollectionReference productRef =
      FirebaseFirestore.instance.collection('Products');
  Stream<QuerySnapshot> getProdduct() async* {
    // CollectionReference productRef =
    //    FirebaseFirestore.instance.collection('Products');
    // productRef.;
  }
  Future<void> addProduct({required ProductModel pro}) async {
    await productRef.add(pro.toMap());
  }

  Future<void> updateProduct(
      {required ProductModel pro, required String docId}) async {
    await productRef.doc(docId).set(pro.toMap());
  }

  Future<void> deleteProduct({required String docId}) async {
    await productRef.doc(docId).delete();
  }
}
