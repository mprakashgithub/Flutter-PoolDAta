import 'dart:convert';

class ProductData{
 final String adsTitle;
 final String price;
  final String image;
  final String mCategory;
  final String locality;
  final String city;
  final String stateName;
  final String productype;
  final String type;

  ProductData({
    this.adsTitle,
    this.price,
    this.image,
    this.mCategory,
    this.locality,
    this.city,
    this.stateName,
    this.productype,
    this.type
    });
    factory ProductData.fromJson(Map<String, dynamic> parsedJson){
    return ProductData(
      adsTitle: parsedJson["AdsTitle"],
      price: parsedJson["Price"],
      image: parsedJson["Image"],
      mCategory: parsedJson["MCategory"],
      city: parsedJson["City"],
      stateName: parsedJson["StateName"],
      productype: parsedJson["Productype"],
      type: parsedJson["Type"]
    );
  }
}