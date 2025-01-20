import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:new_user_app/screen/checkout_page.dart';
import 'package:provider/provider.dart';

import '/provider/my_provider.dart';
import '/screen/home_page.dart';

class CartPage extends StatelessWidget {
  RxBool isLoading = false.obs;
  @override
  Widget cartItem({
    required String? image,
    required String? name,
    required String? price,
    required Function()? onTap,
    required int? quantity,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.only(bottom: 5),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: CircleAvatar(
              backgroundImage: NetworkImage(image!),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              //alignment: Alignment.topRight,
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name!,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: onTap,
                          child: Icon(
                            Icons.close,
                            color: primaryColor,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Qunatity: $quantity",
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Rs. $price",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    double total = provider.totalprice();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: Container(
        //margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 100,
        decoration: BoxDecoration(color: whiteColor),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Sub Total",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  "Rs. $total",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Obx(() => InkWell(
                  onTap: () async {
                    //final CollectionReference orderCollection = FirebaseFirestore.instance.collection('order');
                    try {
                      isLoading(true);
                      DocumentReference documentReference =
                          await FirebaseFirestore.instance
                              .collection('order')
                              .add({
                        "orderId": "",
                        "user_name": "",
                        "orders_list": provider.cartList
                            .map((c) => {
                                  "name": c.name,
                                  "price": c.price,
                                  "quantity": c.quantity,
                                  "image": c.image,
                                })
                            .toList(),
                        "order_status": "queue",
                        "table_no": "",
                        "total_amount": total,
                        "total_items": provider.getCartModelList.length,
                        "special_instructions": "",
                      });
                      await documentReference.update({
                        "orderId": documentReference.id,
                      });
                      await Get.offAll(
                          () => CheckOutPage(
                                id: documentReference.id,
                              ),
                          transition: Transition.fade,
                          duration: Duration(seconds: 1));
                    } catch (e) {
                      isLoading(false);
                    }
                  },
                  child: isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : Container(
                          //padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          width: 300,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Check Out",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                )),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text("Cart"),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => HomePage());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.getCartModelList.length,
                itemBuilder: (context, index) {
                  provider.getDeleteIndex(index);
                  print((provider.cartList[index].toMap()));
                  return cartItem(
                    onTap: () {
                      provider.delete();
                    },
                    image: provider.getCartModelList[index].image,
                    name: provider.getCartModelList[index].name,
                    price: provider.getCartModelList[index].price.toString(),
                    quantity: provider.getCartModelList[index].quantity,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
