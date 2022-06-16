import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods{
  Future<void> addData(productData) async{
    FirebaseFirestore.instance.collection("products").add(productData).catchError((e){
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("products").snapshots();
  }
}