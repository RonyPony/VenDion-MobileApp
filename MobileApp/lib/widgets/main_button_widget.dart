import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  
  String text;
  
  Function onTap;
  String loadingText;
  bool enable;
  
  CustomBtn(
      {Key? key,
      required this.text,
      required this.onTap, 
      this.loadingText = "Loading...",
      required this.enable})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (enable) {
          onTap();
        }
      },
      child: Container(
        width: 366,
        height: 64,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: enable?Color(0xffff5b00): Color(0xffff5b00).withOpacity(.3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                enable?text:loadingText,
                style: TextStyle(
                  color: enable?Colors.white: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
    ),
    );
  }
  
}