import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/UI/common.dart';
import 'package:http/http.dart' as http;
import '../Models/lumpsum.dart';
import '../Models/order.dart';
import '../Models/user.dart';
import '../ui/cards.dart';
import '../ui/custom_tabbar.dart';
import 'DealerDetailPage.dart';
import 'OrderPage.dart';

class DistributorDetailPage extends StatelessWidget {
  final User user;
  DistributorDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DistributorDetailContent(
      user: user,
    );
  }
}

class DistributorDetailContent extends StatefulWidget {
  final User user;
  DistributorDetailContent({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return DistributorDetailState();
  }
}

class DistributorDetailState extends State<DistributorDetailContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar("Information", () {
          Navigator.pop(context);
        }),
        body: DistributorDetailPageBody()
        // DistributorDetailPageBody(),
        );
  }

  var f = 0;
  String? id;
  List<User> child = [];
  List<Order> orderList = [];
  var userType;
  loadChildData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userType = await prefs.getString('userType');
    if (f == 0) {
      orderList = [];
      child = [];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = await prefs.getString('id');
      String uri;
      uri = "http://steefotmtmobile.com/steefo/getchildren.php";

      var res = await http.post(Uri.parse(uri), body: {
        "id": widget.user.id,
      });

      var responseData = json.decode(res.body);
      print(responseData['data'].length);
      for (int i = 0; i < responseData['data'].length; i++) {
        User u = User();
        u.id = responseData["data"][i]["id"];
        u.userType = responseData["data"][i]["userType"];
        u.orgName = responseData["data"][i]["orgName"];
        u.address = responseData["data"][i]["address"];
        u.email = responseData["data"][i]["email"];
        u.mobileNumber = responseData["data"][i]["mobileNumber"];
        u.gstNumber = responseData["data"][i]["gstNumber"];
        u.panNumber = responseData["data"][i]["panNumber"];
        u.adhNumber = responseData["data"][i]["adhNumber"];
        print(u);
        child.add(u);
        //  print("usertype${widget.user.userType}");
      }

      res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": widget.user.id!},
      );
      responseData = jsonDecode(res.body);
      //print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.user_type = responseData["data"][i]["userType"];
        req.date = responseData["data"][i]["dateTime"];
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.orderType = responseData["data"][i]["orderType"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.region = responseData["data"][i]["region"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.pincode = responseData["data"][i]["pincode"];
        req.trans_type = responseData["data"][i]["transType"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
        req.party_name = responseData["data"][i]["partyName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        //print(req);
        orderList.add(req);
      }
      f = 1;
      setState(() {});
    }
  }

  Widget DistributorDetailPageBody() {
    loadChildData();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CustomTabBar(
            selectedTitleColor: Colors.white,
            unSelectedTitleColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            unSelectedCardColor: Colors.white,
            titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tabBarItemExtend: widget.user.userType == "Distributor"
                ? ((MediaQuery.of(context).size.width) / 3)
                : ((MediaQuery.of(context).size.width) / 2),
            tabViewItemHeight: MediaQuery.of(context).size.height * 0.7,
            selectedCardColor: Colors.blueGrey,

            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //tabBarItemExtend: ((MediaQuery.of(context).size.width)),
            // tabBarProperties: TabBarProperties(
            //     indicatorColor: Colors.lightBlueAccent,
            //     background: Container(
            //       width: MediaQuery.of(context).size.width / 1.5,
            //     )),
            tabBarItems: widget.user.userType == "Distributor"
                ? [
                    'Info',
                    'Dealers',
                    'Orders',
                  ]
                : [
                    'Info',
                    'Orders',
                  ],
            tabViewItems: widget.user.userType == "Distributor"
                ? [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        children: [
                          // padding: EdgeInsets.symmetric(vertical: 20),
                          // Padding(padding: EdgeInsets.only(bottom: 10)),
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Text(
                                    widget.user.orgName!,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromRGBO(19, 59, 78, 1.0),
                                    )),
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    widget.user.address!,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontSize: 15)),
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Email Id :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.email!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Mobile Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.mobileNumber!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Gst Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.gstNumber!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("PAN Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.panNumber!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Aadhar Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.adhNumber!,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     margin: EdgeInsets.only(top: 10),
                              //     padding: EdgeInsets.symmetric(horizontal: 20),
                              //     child: ElevatedButton(
                              //       style: ButtonStyle(
                              //         shape: MaterialStatePropertyAll(
                              //             ContinuousRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(20))),
                              //         backgroundColor: MaterialStatePropertyAll(
                              //             Colors.green),
                              //       ),
                              //       onPressed: () {
                              //         Get.to(InventoryPage());
                              //       },
                              //       child: Text("View Inventory"),
                              //     )),
                            ],
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Container(
                          //     margin: EdgeInsets.symmetric(
                          //         vertical: 30, horizontal: 10),
                          //     padding: EdgeInsets.symmetric(horizontal: 10),
                          //     decoration: BoxDecoration(
                          //         color: Colors.green,
                          //         borderRadius: BorderRadius.circular(20)),
                          //     child: Text(
                          //       widget.user.userType!,
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          // width: 500,
                          // width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ListView.builder(
                                reverse: true,
                                itemCount: child.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DealerDetailPage(
                                                        user: child[index])));
                                      },
                                      child: DealerCard(child[index], context));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ListView.builder(
                                reverse: true,
                                itemCount: orderList.length,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetails(
                                                      order: orderList[index],lumpsum: Lumpsum()
                                                    )));
                                      },
                                      child: orderList[index].user_type ==
                                              "Distributor"
                                          ? orderCard(context, orderList[index],
                                              widget.user.id)
                                          : Container());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                : [
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        children: [
                          // padding: EdgeInsets.symmetric(vertical: 20),
                          // Padding(padding: EdgeInsets.only(bottom: 10)),
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Text(
                                    widget.user.orgName!,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromRGBO(19, 59, 78, 1.0),
                                      // color: Colors.green
                                    )),
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    widget.user.address!,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontSize: 15)),
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Email Id :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.email!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Mobile Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.mobileNumber!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Gst Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.gstNumber!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("PAN Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.panNumber!,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Aadhar Number :",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))),
                                    Text(
                                      widget.user.adhNumber!,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     margin: EdgeInsets.only(top: 10),
                              //     padding: EdgeInsets.symmetric(horizontal: 20),
                              //     child: ElevatedButton(
                              //       style: ButtonStyle(
                              //         shape: MaterialStatePropertyAll(
                              //             ContinuousRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(20))),
                              //         backgroundColor: MaterialStatePropertyAll(
                              //             Colors.green),
                              //       ),
                              //       onPressed: () {
                              //         Get.to(InventoryPage());
                              //       },
                              //       child: Text("View Inventory"),
                              //     )),
                            ],
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Container(
                          //     margin: EdgeInsets.symmetric(
                          //         vertical: 30, horizontal: 10),
                          //     padding: EdgeInsets.symmetric(horizontal: 10),
                          //     decoration: BoxDecoration(
                          //         color: Colors.green,
                          //         borderRadius: BorderRadius.circular(20)),
                          //     child: Text(
                          //       widget.user.userType!,
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ListView.builder(
                                reverse: true,
                                itemCount: orderList.length,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OrderPage(
                                                      order: orderList[index],
                                                    )));
                                      },
                                      child: orderCard(context,
                                          orderList[index], widget.user.id));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
          ),
        ],
      ),
    );
  }
}
