import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kharido_becho/Product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        accentColor: Colors.orange,
        primaryColor: Colors.orange,
       
      ),
      home: MyHomePage(title: 'Kharido Becho'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      "https://kharedobecho.com/api/HomeDataList?State=Harayana&City=Gurugram&Locality=Sector%2043";

  List<ProductData> postFromJson(String str) {
    final jsonData = json.decode(str);
    return List<ProductData>.from(
        jsonData["HomeResult"].map((x) => ProductData.fromJson(x)));
  }

  Future<List<ProductData>> getData() async {
    final response = await http.get(url);
    return postFromJson(response.body);
  }

  Widget productWidget() {
    return FutureBuilder(
        future: getData(),
        builder: (context, productSnap) {
          switch (productSnap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                itemCount: productSnap.data.length,
                itemBuilder: (context, index) {
                  ProductData productData = productSnap.data[index];
                  return Card(
                    elevation: 1,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 15.0),
                      leading: CachedNetworkImage(
                        imageUrl:
                            productData.image != null ? productData.image : '',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      offset: Offset(0.0, 6.0,),
                                      spreadRadius: 5.0
                                    )
                                  ],
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images.png"),
                      ),
                      title: Container(
                        width: 50.0,
                        child: Text(
                          '${productData.adsTitle != null ? productData.adsTitle : 'title'}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              fontSize: 18.0,
                              color: Colors.black87,
                              letterSpacing: 2
                              )
                              ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Text(
                        '${productData.mCategory != null ? productData.mCategory : ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                              fontSize: 18.0,
                              color: Colors.black87,
                              letterSpacing: 2
                              )
                              ),
                      )
                      ),
                      trailing: Text(
                        '\₹ ${productData.price != null ? productData.price : 'price'}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                           fontFamily: 'DancingScript',
                           fontWeight: FontWeight.w700,
                           fontSize: 14.0,
                           letterSpacing: 1.5
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.title}",style: TextStyle(color:Colors.white),),
            centerTitle: true,
          ),
          body: productWidget()),
    );
  }
}