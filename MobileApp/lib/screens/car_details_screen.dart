import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/main_button_widget.dart';
import 'home_screen.dart';

class VehicleDetails extends StatefulWidget {
  static String routeName = "/vehicleDetails";

  VehicleDetails({Key? key}) : super(key: key);

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [Icon(Icons.share_rounded)],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGallery(),
            _buildTitle(),
            _buildDescription(),
            _buildFeatures(),
            _buildOptions(),
            _buildBuyNowBtn(),
            SizedBox(height: 40,)
             ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Image.asset("assets/carDetailsPlaceholder.png"),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .35),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      child: Image.asset("assets/carDetailsPlaceholder.png"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      child: Image.asset("assets/carDetailsPlaceholder.png"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      child: Image.asset("assets/carDetailsPlaceholder.png"),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  _buildTitle() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 20),
              child: Text(
                "Telsa Model 3",
                style: TextStyle(
                  color: Color(0xff040415),
                  fontSize: 22,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*.3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "4.5/5",
                style: TextStyle(
                  color: Color(0xffff5b00),
                  fontSize: 18.64,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 6.55),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(Icons.star_rounded,color: Color(0xffff5b00),),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Opacity(
                opacity: 0.50,
                child: Text(
                  "Rs. 18,00,000.00",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xff040415),
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
  
  _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 20,left: 20),
      child: Opacity(
          opacity: 0.40,
          child: Column(
            children: [
              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas diam nam eu nulla a. Vestibulum aliquet facilisi interdum nibh blandit ",
                  style: TextStyle(
                      fontSize: 16,
                  ),
              ),
              Row(
                children: [
                  Text("Read more...",style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffff5b00),
                  ),),
                ],
              )
            ],
          ),
      ),
    );
  }
  
  _buildFeatures() {
    return Padding(
      padding: const EdgeInsets.only(top: 20,left: 20),
      child: Row(
        children: [
          aFeature("Autopilot"),
          aFeature("360° Cameras"),
          SizedBox(width: 10,),
          Opacity(
            opacity: 0.40,
            child: Text(
              "See all",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xff040415),
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
  
  aFeature(String s) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5),bottomLeft:  Radius.circular(5),topLeft:  Radius.circular(5))),
        backgroundColor: Color(0xffff5b00),
        label: Container(
          width:MediaQuery.of(context).size.width*.26*s.length/10,
          child: Row(
            children: [
              Icon(Icons.check_box_rounded,color: Colors.white,),
              Text(s,style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
        ),
    );
  }
  
  _buildOptions() {
    return Opacity(
      opacity: .5,
      child: Padding(
        padding: const EdgeInsets.only(left: 50,top: 15),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [Icon(Icons.handshake_rounded,),Text("Contact Dealer")],                
                ),
                SizedBox(width: MediaQuery.of(context).size.width*.14,),
                Row(
                  children: [
                    Icon(Icons.car_rental),
                    Text("Car Details")
                  ],
                ),
              ],
            ),
            SizedBox(height:10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [Icon(Icons.location_on), Text("Santo Domingo Este")],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Row(
                  children: [Icon(Icons.attach_money), Text("Financiamiento")],
                ),
                ],
            )
          ],
        ),
      ),
    );
  }
  
  _buildBuyNowBtn() {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          },
          child: CustomBtn(
            onTap: () {},
            enable: true,
            text: "Buy Now",
          ),
        ),
      );
    }
  
}
