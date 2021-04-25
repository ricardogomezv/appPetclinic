import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class VetList {
  final List<dynamic> products;

  VetList({
    required this.products,
  });

  factory VetList.fromJson(Map<String, dynamic> parsedJson) {
    Iterable list = parsedJson['vetList'];

    List<Product> products = list.map((i) => Product.fromJson(i)).toList();

    return new VetList(products: products);
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final Double price;
  final int existence;
  final String photo;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.existence,
      required this.photo});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      existence: json['existence'],
      photo: json['photo']);
}
