import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:new_user_app/provider/my_provider.dart';
import 'package:new_user_app/screen/home_page.dart';
import 'package:provider/provider.dart';

class LastScreen extends StatefulWidget {
  const LastScreen({super.key});

  @override
  State<LastScreen> createState() => _LastScreenState();
}

class _LastScreenState extends State<LastScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    MyProvider provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Your Order has been placed ',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                ),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'successfuly!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.07,
            ),
            InkWell(
              onTap: () {
                provider.cartList.clear();
                Get.offAll(() => HomePage());
              },
              child: Container(
                height: 45,
                width: 250,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Back to Home Screen",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
