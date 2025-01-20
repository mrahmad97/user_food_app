import 'package:flutter/material.dart';

class CartModle {
  final String? image;
  final String? name;
  final double? price;
  final int? quantity;

  CartModle({
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map toMap() {
    return {'name': name, 'quantity': quantity, 'price': price};
  }

  Map<String, dynamic> toJson() => {
        'image': image,
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  factory CartModle.fromJson(Map<String, dynamic> json) {
    return CartModle(
      image: json['image'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
