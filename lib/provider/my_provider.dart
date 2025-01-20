import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_user_app/modles/product_modle.dart';

import '/modles/cart_modle.dart';

class MyProvider extends ChangeNotifier {
/////////////add to cart ////////////
  List<CartModle> cartList = [];
  List<CartModle> checkOutList = [];

  CartModle? cartModle;
  CartModle? checkOutModle;
  void addToCart({
    required String? image,
    required String? name,
    required double? price,
    required int? quantity,
  }) {
    cartModle = CartModle(
      image: image!,
      name: name!,
      price: price!,
      quantity: quantity!,
    );
    cartList.add(cartModle!);
  }

  List<CartModle> get getCartModelList {
    return List.from(cartList);
  }

  void getCheckOutData({
    required String? image,
    required String? name,
    required double? price,
    required int? quantity,
  }) {
    checkOutModle = CartModle(
      image: image!,
      name: name!,
      price: price!,
      quantity: quantity!,
    );
    checkOutList.add(checkOutModle!);
  }

  List<CartModle> get getCheckOutModelList {
    return List.from(checkOutList);
  }

  double totalprice() {
    double total = 0;
    getCartModelList.forEach((element) {
      total += element.price! * element.quantity!;
    });
    return total;
  }

  int? deleteIndex;
  void getDeleteIndex(int index) {
    deleteIndex = index;
  }

  void delete() {
    cartList.removeAt(deleteIndex!);
    notifyListeners();
  }
}
