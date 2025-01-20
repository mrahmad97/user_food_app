import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:velocity_x/velocity_x.dart';

Widget ourButton({onPress, color, textColor, String? title}) {
  return ElevatedButton(
    style:
        ElevatedButton.styleFrom(primary: color, padding: EdgeInsets.all(12)),
    onPressed: onPress,
    child: title!.text.color(textColor).make(),
  );
}

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.size(18).color(textColor).make(),
        Divider(),
        10.heightBox,
        "Are you sure you want to exit?".text.size(16).color(textColor).make(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(
              color: primaryColor,
              onPress: () {
                SystemNavigator.pop();
              },
              textColor: whiteColor,
              title: "Yes",
            ),
            ourButton(
              color: primaryColor,
              onPress: () {
                Navigator.pop(context);
              },
              textColor: whiteColor,
              title: "No",
            )
          ],
        )
      ],
    ).box.color(lightGreyColor).padding(EdgeInsets.all(12)).roundedSM.make(),
  );
}
