import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipssi_projet/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late String authorName, title, desc;

  CrudMethods crudMethods = CrudMethods();

  File? selectedImage;
  bool _isLoading = false;

  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  uploadProduct() async{
    if(selectedImage!=null){
      setState(() {
        _isLoading = true;
      });
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("productImages").child("${randomAlphaNumeric(9)}.jpg");
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task.whenComplete(() => {})).ref.getDownloadURL();
      print("url: $downloadUrl");

      Map<String, String> productMap = {
        "imgUrl": downloadUrl,
        "authorName": authorName,
        "Title": title,
        "Description": desc
      };
      
      crudMethods.addData(productMap).then((value) => {Navigator.pop(context)});
    }else{

    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Market",
              style: TextStyle(fontSize: 22, color: Colors.red),
            )
          ],),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadProduct();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      )
        :Container(child: Column(children: <Widget>[
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child:  selectedImage != null
                ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(selectedImage!, fit: BoxFit.cover,)
                  ),
                )
                : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Colors.black45,
                  ),
                )
          ),
          const SizedBox(height: 8,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: <Widget>[
              TextField(
                decoration: const InputDecoration(hintText: "Author Name"),
                onChanged: (val){
                  authorName = val;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Title"),
                onChanged: (val){
                  title = val;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Description"),
                onChanged: (val){
                  desc = val;
                },
              )
          ],),)
        ],),),
    );
  }
}
