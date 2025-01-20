import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:new_user_app/screen/detail_page.dart';
import 'package:new_user_app/screen/widget/bottom_Contianer.dart';
import 'package:velocity_x/velocity_x.dart';

class SpecificCategoryItems extends StatefulWidget {
  final String categoryName;
  final String catId;
  SpecificCategoryItems({
    required this.categoryName,
    required this.catId,
  });
  @override
  State<SpecificCategoryItems> createState() => _SpecificCategoryItemsState();
}

class _SpecificCategoryItemsState extends State<SpecificCategoryItems> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.categoryName),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('menu').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                String categoryId = widget.catId;
                print(categoryId);
                int length = snapshot.data!.docs
                    .where((element) => element['catId'] == categoryId)
                    .length;
                print(length.toString());
                var data = snapshot.data!.docs
                    .where((element) => element['catId'] == categoryId);
                List<dynamic> items = [];
                data.forEach((element) {
                  items.add({
                    "name": element['Name'],
                    "imageUrl": element['imageUrl'],
                    "price": element['itemPrice'],
                    "itemDesc": element['itemDescription'],
                  });
                });
                print(items);

                return ListView.builder(
                    // gridDelegate:
                    //     const SliverGridDelegateWithFixedCrossAxisCount(
                    //   crossAxisCount: 2,
                    //   childAspectRatio: 2 / 2.3,
                    // ),
                    itemCount: length,
                    itemBuilder: (context, index) {
                      var menu = snapshot.data!.docs[index];
                      return BottomContainer(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                image: items[index]['imageUrl'],
                                price: items[index]['price'],
                                name: items[index]['name'],
                                description: items[index]['itemDesc'],
                              ),
                            ),
                          );
                        },
                        image: items[index]['imageUrl'],
                        price: items[index]['price'],
                        name: items[index]['name'],
                      );
                    });
              }
              return Text(
                'There is no menu',
              );
            }),
      ),
    );
  }
}
