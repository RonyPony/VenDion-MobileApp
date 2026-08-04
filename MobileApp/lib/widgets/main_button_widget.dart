import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendion/config/app_constants.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool mainBtn;
  final String loadingText;
  final bool enable;

  const CustomBtn(
      {Key? key,
      required this.text,
      required this.onTap,
      this.loadingText = "Loading...",
      required this.mainBtn,
      required this.enable})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color enabledColor = mainBtn ? AppColors.primary : Colors.grey;
    final Color backgroundColor =
        enable ? enabledColor : enabledColor.withOpacity(.3);

    return mainBtn
        ? GestureDetector(
            onTap: () {
              if (enable) {
                onTap();
              }
            },
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 366),
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enable ? text : loadingText,
                    style: TextStyle(
                      color:
                          enable ? Colors.white : Colors.white.withOpacity(.6),
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              if (enable) {
                onTap();
              }
            },
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 366),
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enable ? text : loadingText,
                    style: TextStyle(
                      color:
                          enable ? Colors.white : Colors.white.withOpacity(.6),
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
