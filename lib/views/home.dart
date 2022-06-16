import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipssi_projet/services/crud.dart';
import 'package:flutter_ipssi_projet/views/create_product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  CrudMethods crudMethods = CrudMethods();

  late Stream<QuerySnapshot> productsStream;

  Widget ProductsList(){
    return Container(
      child: productsStream != null ?
      Column(children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: productsStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return ProductsTile(
                        imgUrl:  snapshot.data?.docs[index].get("imgUrl"),
                        title:  snapshot.data?.docs[index].get("title"),
                        description:  snapshot.data?.docs[index].get("desc"),
                        authorName:  snapshot.data?.docs[index].get("authorName")
                    );
                  });
            }
        )
      ],)
      : Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator()
      ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result){
      setState(() {
        productsStream = result;
      });
    });

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
      ),
      body: Container(),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          FloatingActionButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateProduct()));
            },
            child: const Icon(Icons.add)
          )
        ],),
      ),
    );
  }
}

class ProductsTile extends StatelessWidget {

  String imgUrl, title, description, authorName;
  ProductsTile({required this.imgUrl, required this.title, required this.description, required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover
            )
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)), const SizedBox(height: 4,),
                Text(description, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)), const SizedBox(height: 4,),
                Text(authorName)
              ]
            ),
          )
        ],
      ),
    );
  }
}