import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vendion/screens/login_screen.dart';

import '../widgets/main_button_widget.dart';
import '../widgets/textBox_widget.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/registerScreen";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLogo(),
            _buildTitle(),
            _buildForm(),
            _buildRegisterBtn(),
            _buildSplitter(),
            _buildRegisterWith(),
            _buildAlreadyMember(),
          ],
        ),
      ),
    );
  }

  _buildLogo() {
    const String assetName = 'assets/logo.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'Acme Logo');
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          svg,
        ],
      ),
    );
  }

  _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Registrate ! ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff040415),
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: 388,
            child: Text(
              "Encuentra tu carro ideal",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildForm() {
    const String assetName = 'assets/user.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: ' Logo');
    final Widget emailSvg = SvgPicture.asset('assets/lock.svg', semanticsLabel: ' Logo');
    return Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: MediaQuery.of(context).size.height * .03),
        child: Column(
          children: [
            CustomTextBox(
              onChange: () {},
              svg: svg,
              text: "Nombre Completo",
              isPassword: false,
              controller: _userController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextBox(
              onChange: () {},
              svg: emailSvg,
              text: "Email",
              isPassword: false,
              controller: _userController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextBox(
              onChange: () {},
              svg: svg,
              text: "Telefono",
              isPassword: false,
              controller: _userController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextBox(
              onChange: () {},
              svg: svg,
              text: "Clave",
              isPassword: false,
              controller: _userController,
            ),
          ],
        ));
  }

  _buildRegisterBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomBtn(
        onTap: () {},
        text: "Register",
      ),
    );
  }

  _buildRegisterWith() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Registrate con",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset('assets/facebook.svg'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset('assets/instagram.svg'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset('assets/youtube.svg'),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  _buildSplitter() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: 366,
        height: 22,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 164,
              height: 1,
              color: const Color(0xffc4c4c4),
            ),
            const SizedBox(width: 8.50),
            const Text(
              "Or",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xffc4c4c4),
                fontSize: 14,
                fontFamily: "Spartan",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.50),
            Container(
              width: 164,
              height: 1,
              color: const Color(0xffc4c4c4),
            ),
          ],
        ),
      ),
    );
  }

  _buildAlreadyMember() {
    return Padding(
      padding: const EdgeInsets.only(top: 30,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          const Opacity(
            opacity: 0.40,
            child: Text(
              "Ya tienes una cuenta?   ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff040415),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
            },
            child: const Text(
              "Accede ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xffff5b00),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
