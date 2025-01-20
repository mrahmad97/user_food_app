import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_user_app/constants/colors.dart';
import 'package:new_user_app/screen/cart_page.dart';
import 'package:new_user_app/screen/category_items.dart';
import 'package:new_user_app/screen/widget/exit_dialog.dart';
import 'package:provider/provider.dart';
import '../provider/my_provider.dart';
import '/screen/detail_page.dart';
import '/screen/widget/bottom_Contianer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget categoriesContainer(
      {@required Function()? onTap,
      @required String? image,
      @required String? name}) {
    return Container(
      height: 80,
      width: 80,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image!), fit: BoxFit.fill),
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              name!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    MyProvider provider = Provider.of<MyProvider>(context);

    return WillPopScope(
        onWillPop: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => exitDialog(context));
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.all(6.0),
              child:
                  CircleAvatar(backgroundImage: AssetImage("images/chai.jpg")),
            ),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    right: 16,
                  ),
                  child: badges.Badge(
                      badgeStyle: badges.BadgeStyle(badgeColor: primaryColor),
                      position:
                          badges.BadgePosition.custom(start: 30, bottom: 23),
                      badgeContent: Consumer<MyProvider>(
                        builder: (context, value, child) {
                          return Text(
                            provider.cartList.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          );
                        },
                      ),
                      child: IconButton(
                          onPressed: () {
                            Get.to(() => CartPage());
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.black45,
                          )))),
            ],
          ),
          body: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8,
                ),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                height: size.height * 0.15,
                // width: 350,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('category')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }
                    if (snapshot.hasData) {
                      return Container(
                        height: 250,
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot cate =
                                  snapshot.data!.docs[index];
                              return categoriesContainer(
                                onTap: () {
                                  Get.to(() => SpecificCategoryItems(
                                        categoryName: cate['Name'],
                                        catId: cate['catId'],
                                      ));
                                },
                                image: cate["imageUrl"],
                                name: cate["Name"],
                              );
                            }),
                      );
                    }
                    return Text(
                      'There is no category',
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8,
                ),
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('menu')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs
                                  .where((element) =>
                                      element['isAvailable'] == true)
                                  .length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot menu =
                                    snapshot.data!.docs[index];
                                // if (menu['isAvailable'] == true) {
                                return BottomContainer(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          image: menu['imageUrl'],
                                          price: menu['itemPrice'],
                                          name: menu['Name'],
                                          description: menu['itemDescription'],
                                        ),
                                      ),
                                    );
                                  },
                                  image: menu['imageUrl'],
                                  price: menu['itemPrice'],
                                  name: menu['Name'],
                                );
                              } /*else {
                              return SizedBox(
                                height: 0,
                              );
                            }*/
                              );
                        }
                        return Text(
                          'There is no menu',
                        );
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
