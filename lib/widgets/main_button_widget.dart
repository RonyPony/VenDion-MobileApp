import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  
  String text;
  
  Function onTap;

  CustomBtn(
      {Key? key,
      required this.text,
      required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(),
      child: Container(
        width: 366,
        height: 64,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffff5b00),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                text,
                style: TextStyle(
                  color: Colors.white,
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