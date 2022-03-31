import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../constant/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mobileNumberController = TextEditingController();
  AuthService authService = AuthService();
  String verificationID = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 239, left: 39),
            child: Text(
              'Continue with Phone',
              style: TextStyle(
                  fontFamily: 'Robot',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 24,
                  letterSpacing: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 57, left: 39, right: 35),
            child: TextFormField(
                controller: mobileNumberController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  // enabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.cyan),
                  // ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.m3primary),
                  ),
                  fillColor: AppColors.m3primary,
                  focusColor: AppColors.m3primary,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(
                    Icons.call_outlined,
                    color: AppColors.icon,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "input",
                  labelText: "Mobile Number",
                  labelStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: AppColors.m3primary),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF79747E),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 79,
              ),
              child: Center(
                child: SizedBox(
                  width: 117,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        authService.signinWithPhone(
                            mobileNumberController.text, context);
                      },
                      child: const SizedBox(
                        width: 69,
                        height: 20,
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: AppColors.m3primary,
                      )),
                ),
              ))
        ],
      ),
    );
  }
}
