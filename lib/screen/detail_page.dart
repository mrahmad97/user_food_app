import 'package:flutter/material.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:provider/provider.dart';

import '/provider/my_provider.dart';
import '/screen/cart_page.dart';
import '/screen/home_page.dart';

class DetailPage extends StatefulWidget {
  final String image;
  final String price;
  final String name;
  final String description;
  DetailPage({
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        title: Text("Detail"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Icon(
                                Icons.remove,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Rs. ${(double.tryParse(widget.price)! * quantity)}",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(color: textColor),
                  ),
                  InkWell(
                    onTap: () {
                      provider.addToCart(
                        image: widget.image,
                        name: widget.name,
                        price: double.tryParse(widget.price),
                        quantity: quantity,
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor,
                      ),
                      height: 45,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add to Cart",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
