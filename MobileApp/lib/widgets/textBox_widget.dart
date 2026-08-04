import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    Key? key,
    required this.text,
    required this.controller,
    required this.onChange,
    this.isPassword = false,
    required this.svg,
    this.canBeEmpty = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final String text;
  final bool isPassword;
  final bool canBeEmpty;
  final TextInputType keyboardType;
  final VoidCallback onChange;
  final Widget svg;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 366),
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
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
        color: isDark ? const Color(0xff1d1d24) : Colors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: svg,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: keyboardType,
              validator: (value) {
                if (!canBeEmpty) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor escribe $text';
                  }
                }
                return null;
              },
              onChanged: (_) => onChange(),
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: text,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : const Color(0xffa8afb9),
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
