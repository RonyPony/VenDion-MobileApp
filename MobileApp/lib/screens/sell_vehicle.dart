import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/drawer.dart';
import '../widgets/main_button_widget.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';

class SellScreen extends StatefulWidget {
  static String routeName = "/sellScreen";

  @override
  State<SellScreen> createState() => _buildState();
}

class _buildState extends State<SellScreen> {
  int? _condition = 0;
  List<String> tags = ["Alarm", "Bluetooth","Cruise Control","Front Parking Sensor"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: GeneralDrawer(),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * .1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NotificationsScreen.routeName);
                },
                child: SvgPicture.asset("assets/notification-active.svg")),
          )
        ],
        title: const Text(
          "VenDion",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffff5b00),
            fontSize: 24,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLabel("Title"),
            _splitter(.01),
            _buildTitle(),
            _splitter(.02),
            _buildConditionAndYear(),
            _splitter(.02),
            _buildLabel("Features"),
            _splitter(.01),
            _buildSearch(),
            _buildTags(),
            _splitter(.01),
            _buildLocationAndPrice(),
            _splitter(.02),
            _buildLabel("Description"),
            _splitter(.01),
            _buildDesription(),
            _buildUploadPhotos(),
            _buildSellBtn(),
            _buildGoBackBtn()
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0
                  // right: MediaQuery.of(context).size.width/3,
                  ),
              child: Row(
                children: [
                  Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        // cursorHeight: 30,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          hintText: "Enter title",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))
                  // Text(
                  //   "Enter title",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildLabel(String s) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 28),
      child: Row(
        children: [
          Text(
            s,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _buildConditionAndYear() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              _buildLabel("Condition"),
              _buildCondition(),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [_buildLabel("Year"), _buildYearField()],
          ),
        )
      ],
    );
  }

  _splitter(double base) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * base,
    );
  }

  _buildCondition() {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Radio(
              value: _condition!,
              groupValue: 0,
              onChanged: (int? value) {
                _condition = value;
                print(_condition);
                setState(() {});
              },
            ),
            Text("New"),
            SizedBox(
              width: 10,
            ),
            Radio(
              value: _condition!,
              groupValue: 1,
              onChanged: (int? value) {
                _condition = value;
                print(_condition);
                setState(() {});
              },
            ),
            Text("Used"),
          ],
        ));
  }

  _buildYearField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    child: TextField(
                      // cursorHeight: 30,
                      cursorColor: Color(0xffff5b00),
                      decoration: InputDecoration(
                        hintText: "Enter title",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                  // Text(
                  //   "Enter year",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0
                  // right: MediaQuery.of(context).size.width/3,
                  ),
              child: Row(
                children: [
                  Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        // cursorHeight: 30,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))
                  // Text(
                  //   "Enter title",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildTags() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Chip(
            label: Text(tags[index]),
            backgroundColor: Colors.white,
            onDeleted: () {
              setState(() {
                tags.remove(tags[index]);
              });
            },
            avatar: Icon(
              Icons.local_offer,
              color: Color(0xffff5b00),
            ),
          );
        },
      ),
    );
    // return Column(
    //   children: [
    //     Column(
    //       children: [
    //         Row(
    //           children: [
    //             _aTag("Alarm"),
    //              _aTag("Cruise Control")
    //              ],
    //         ),
    //         Row()
    //       ],
    //     ),
    //     Column(
    //       children: [
    //         Row(
    //           children: [
    //             _aTag("Bluetooth"),
    //             _aTag("Front parkinf sensor"),
    //           ],
    //         ),
    //         Row()
    //       ],
    //     )
    //   ],
    // );
  }

  _aTag(String s) {
    bool selected = true;

    return Chip(
        backgroundColor: Colors.white,
        onDeleted: () {
          print("rrr");
        },
        avatar: Icon(
          Icons.local_offer,
          color: Color(0xffff5b00),
        ),
        // Container(
        //   height: 15,
        //   width: 15,

        //   decoration: BoxDecoration(
        //       color: !selected?Colors.white:Color(0xffff5b00),
        //       borderRadius: BorderRadius.circular(2),
        //       border: Border.all(width: 2)),
        // ),
        label: Text(s));
  }
  
  _buildLocationAndPrice() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              _buildLabel("Location"),
              _buildLocationField(),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              _buildLabel("Price"), 
              _buildPriceField()
              ],
          ),
        )
      ],
    );
  }
  
  _buildLocationField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    child: TextField(
                      // cursorHeight: 30,
                      cursorColor: Color(0xffff5b00),
                      decoration: InputDecoration(
                        hintText: "Location",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                  // Text(
                  //   "Enter year",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xff8c9199),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  _buildPriceField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(
                left: 0,
                top: 0,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    child: TextField(
                      // cursorHeight: 30,
                      cursorColor: Color(0xffff5b00),
                      decoration: InputDecoration(
                        hintText: "Enter price",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  _buildDesription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffedeeef),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0
                  // right: MediaQuery.of(context).size.width/3,
                  ),
              child: Row(
                children: [
                  Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines:
                            5,
                        // cursorHeight: 30,
                        cursorColor: Color(0xffff5b00),
                        decoration: InputDecoration(
                          hintText: "Enter Description",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))
                 
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  _buildUploadPhotos() {
    return Row(
      children: [
        SvgPicture.asset("assets/uploadImage.svg",),
        SizedBox(
          width: 180,
          child: Text(
            "Upload images/Video",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
  
  _buildGoBackBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomBtn(
        mainBtn: false,
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        },
        enable: true,
        text: "Regresar",
      ),
    );
  }
  
  _buildSellBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        },
        child: CustomBtn(
          mainBtn: true,
          onTap: () {},
          enable: true,
          text: "Sell it now!",
        ),
      ),
    );
  }
}
