import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendion/models/client_user.dart';
import 'package:vendion/models/serverResponse.dart';
import 'package:vendion/models/user_register.dart';
import 'package:vendion/providers/auth_provider.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController repPass = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  
  bool isRegistering = false;

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
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
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
    final Widget lockSvg = SvgPicture.asset('assets/lock.svg', semanticsLabel: ' Logo');
    return Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: MediaQuery.of(context).size.height * .03),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextBox(
                onChange: () {
                  // _formKey.currentState!.validate();
                },
                svg: svg,
                keyboardType: TextInputType.name,
                text: "Nombre",
                isPassword: false,
                controller: _nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextBox(
                onChange: () {},
                svg: Icon(Icons.family_restroom_rounded,color: Colors.grey,),
                keyboardType: TextInputType.name,
                text: "Apellidos",
                isPassword: false,
                controller: _lastNameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextBox(
                onChange: () {},
                svg: Icon(Icons.email_outlined,color: Colors.grey,),
                keyboardType: TextInputType.emailAddress,
                text: "Email",
                isPassword: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextBox(
                onChange: () {},
                svg: Icon(Icons.phone,color: Colors.grey,),
                keyboardType: TextInputType.phone,
                text: "Telefono",
                isPassword: false,
                controller: _phoneController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextBox(
                onChange: () {},
                svg: lockSvg,
                text: "Clave",
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                controller: _passController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextBox(
                onChange: () {},
                svg: lockSvg,
                text: "Rep. Clave",
                isPassword: true,
                controller: repPass,
              ),
            ],
          ),
        ));
  }

  _buildRegisterBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomBtn(
        mainBtn: true,
        enable: !isRegistering,
        loadingText: "Registrando...",
        onTap: () async {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          setState(() {
            isRegistering = true;
          });
          if (_passController.text != repPass.text) {
            return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text("Las claves no coinciden"),
            ));
          }
          
          if (_formKey.currentState!.validate()) {
            final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(_emailController.text);
            if (!emailValid) {
              return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text("Este correo electronico no es valido"),
              ));
            }
          final provider =
                Provider.of<AuthenticationProvider>(context, listen: false);
            UserToRegister usr = UserToRegister(
                name: _nameController.text,
                lastName: _lastNameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                password: _passController.text);
            ServerResponse response = await provider.register(usr);
            print(response.success);
            if (!response.success!) {
              setState(() {
                isRegistering = false;
              });
              return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(response.message!),
              ));
            }
            if (response.success!) {
              setState(() {
                isRegistering = false;
              });
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Registro completado"),
              ));
              Navigator.pop(context);
            }
            
          }
            
          setState(() {
            isRegistering = false;
          });
        },
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
      padding: const EdgeInsets.only(top: 10,bottom: 10),
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
