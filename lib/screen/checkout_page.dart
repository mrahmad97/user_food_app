import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:new_user_app/screen/last_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class CheckOutPage extends StatefulWidget {
  final String id;
  CheckOutPage({Key? key, required this.id}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  RxBool isLoading = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController tableNo = TextEditingController();
  TextEditingController instructions = TextEditingController();
  final key = GlobalKey<FormState>();

  var playerID;
  String getPlayerId = '';
  Future<String?> getPlayerID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot =
        await collection.doc('bTJLub7ageTpjCjvDIiVtygylj32').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      playerID = data?['oneSignalPlayerId'];
      print('this is the final ${playerID}');
    }
    getPlayerId = pref.getString(PLAYER_ID) ?? "";
    print('get pref player id ${getPlayerID}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayerID();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Card(
                elevation: 2,
                child: Container(
                  height: size.height * 0.8,
                  color: whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: key,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(
                              title: "Enter your Name",
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            textField(
                              controller: name,
                              onTap: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid name';
                                } else
                                  null;
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            text(
                              title: "Enter your Table#",
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            textField(
                                controller: tableNo,
                                keyboardType: TextInputType.number,
                                onTap: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter valid table no.';
                                  } else
                                    null;
                                }),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            text(
                              title: "Any Special Instructions",
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            textField(controller: instructions, maxLines: 3),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            InkWell(
                              onTap: () async {
                                if (key.currentState!.validate()) {
                                  try {
                                    isLoading(true);
                                    DocumentReference orders =
                                        await FirebaseFirestore.instance
                                            .collection('order')
                                            .doc(widget.id);
                                    await orders.update({
                                      "user_name": name.text,
                                      "table_no": tableNo.text,
                                      "special_instructions": instructions.text,
                                      'oneSignalId': getPlayerId
                                    });

                                    ///send notification
                                    sendPushNotifications(
                                        title: 'Chai Chubara',
                                        content: 'New Order',
                                        listUser: [playerID],
                                        orderId: widget.id);
                                    await Get.to(
                                      () => LastScreen(),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                    );
                                  } catch (e) {
                                    isLoading(false);
                                  }
                                }
                              },
                              child: Obx(
                                () => Center(
                                  child: Container(
                                    height: 45,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: isLoading == true
                                          ? CircularProgressIndicator(
                                              color: whiteColor,
                                            )
                                          : Text(
                                              "Place Order",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    String? Function(String?)? onTap,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: primaryColor,
      validator: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            borderSide: BorderSide(
              color: primaryColor,
              width: 1,
            )),
      ),
    );
  }

  Widget text({
    required String title,
  }) {
    return Text(
      title,
      style: TextStyle(color: Colors.black, fontSize: 14),
    );
  }
}
