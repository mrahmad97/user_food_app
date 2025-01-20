import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:new_user_app/screen/home_page.dart';
import 'package:velocity_x/velocity_x.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height * 0.76,
              width: size.width,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey)],
                color: lightGreyColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(size.width, 130.0),
                ),
              ),
              child: Column(children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  "Chaye Chobara",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Image.asset(
                  "images/chai.jpg",
                  width: size.width * 0.7,
                ).box.roundedFull.clip(Clip.antiAlias).make(),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  "The Fastest Way",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "of",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Ordering Food",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: InkWell(
                onTap: () async {
                  await Get.offAll(
                    () => HomePage(),
                    transition: Transition.rightToLeft,
                    duration: Duration(seconds: 1),
                  );
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Center(
                    child: Text("Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
