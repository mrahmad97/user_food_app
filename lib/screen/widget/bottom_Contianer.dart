import 'package:flutter/material.dart';
import 'package:new_user_app/constants/colors.dart';

class BottomContainer extends StatelessWidget {
  final String? image;
  final String? name;
  final String? price;
  final Function()? onTap;
  BottomContainer(
      {required this.onTap,
      required this.image,
      required this.price,
      required this.name});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
          child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: lightGreyColor,
                  radius: 50,
                  backgroundImage: NetworkImage(image!),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      "Rs. " + price!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
