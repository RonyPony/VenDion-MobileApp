import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/contracts/auth_contract.dart';
import 'package:vendion/models/user_login_response.dart';
import 'package:vendion/models/user_response.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/register_screen.dart';

import '../models/client_user.dart';
import '../widgets/main_button_widget.dart';
import '../widgets/textBox_widget.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/loginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLogo(),
              _buildTitle(),
              _buildUserNameField(),
              _buildPasswordField(),
              _buildForgottenPassword(),
              _buildLoginBtn(),
              _buildRegister(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _userController.text = "ronel.cruz.a8@gmail.com";
      _passController.text = "ronel08";
    }
  }

  _buildLogo() {
    const String assetName = 'assets/logo.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'Acme Logo');
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .07),
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Login ",
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
              "Bienvenido a VenDion",
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

  _buildUserNameField() {
    const String assetName = 'assets/user.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'Acme Logo');
    return Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: MediaQuery.of(context).size.height * .05),
        child: CustomTextBox(
          onChange: () {},
          svg: svg,
          text: "Usuario",
          isPassword: false,
          controller: _userController,
        ));
  }

  _buildPasswordField() {
    const String assetName = 'assets/lock.svg';
    final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'Acme Logo');
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: CustomTextBox(
          onChange: () {},
          svg: svg,
          text: "Clave",
          isPassword: true,
          controller: _passController,
        ));
  }

  _buildForgottenPassword() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "Olvidaste la clave ?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xff040415),
          fontSize: 14,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _buildLoginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomBtn(
        mainBtn: true,
        enable: !_loading,
        loadingText: "Validando...",
        onTap: () async {
          setState(() {
            _loading = true;
          });
          String username = _userController.text;
          String pass = _passController.text;
          final authProvider =
              Provider.of<AuthenticationProvider>(context, listen: false);
          ClientUser userInfo = ClientUser(email: username, password: pass);
          UserResponse loggedin =
              await authProvider.authenticateUser(userInfo, true);
          if (!loggedin.hasError!) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Ups, algo paso en el proceso, intentalo luego - ${loggedin.errorInfo}"),
            ));
          }
          setState(() {
            _loading = false;
          });
        },
        text: "Login",
      ),
    );
  }

  _buildRegister() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.40,
            child: Text(
              "No tiene una cuenta ?   ",
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
            onTap: () {
              Navigator.pushNamed(context, RegisterScreen.routeName);
            },
            child: Text(
              "Registrate",
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
