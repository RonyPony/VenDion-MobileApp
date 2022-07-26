import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({Key? key,required this.text,required this.controller, required this.onChange, this.isPassword=false, required this.svg}) : super(key: key);
  final String text;
 final bool isPassword;
 final Function onChange;
 final Widget svg;
 final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 366,
      height: 64,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
              BoxShadow(
                  color: Color(0x0c323247),
                  blurRadius: 8,
                  offset: Offset(0, 3),
              ),
              BoxShadow(
                  color: Color(0x3d0c1a4b),
                  blurRadius: 1,
                  offset: Offset(0, 0),
              ),
          ],
          color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: svg,
          ),
          Container(
            height: 50,
            width: 200,
            child: TextField(
              onChanged: onChange(),
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: text,
                border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                hintStyle: TextStyle(                  
                  color: Color(0xffa8afb9),
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
);
  }
}