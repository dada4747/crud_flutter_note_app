// import 'package:crudassignment/services/auth_service.dart';
// import 'package:crudassignment/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import '../service/auth_service.dart';
import '../constant/app_colors.dart';
import 'home_page.dart';

class PhoneVerification extends StatefulWidget {
  final AuthService authService;
  const PhoneVerification({Key? key, required this.authService})
      : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  OtpFieldController smsController = OtpFieldController();
  String otp = '';

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
              'Verify your phone',
              style: TextStyle(
                  fontFamily: 'Robot',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 24,
                  letterSpacing: 0.5),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 36, left: 39),
            child: Text(
              'Enter code ',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: AppColors.m3primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 39,
            ),
            child: OtpTextField(
              numberOfFields: 6,
              fieldWidth: 49,
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(fontFamily: "Roboto", fontSize: 14),
              enabledBorderColor: AppColors.icon,
              crossAxisAlignment: CrossAxisAlignment.start,
              focusedBorderColor: AppColors.m3primary,
              showFieldAsBox: true,
              borderWidth: 1.0,
              borderRadius: BorderRadius.circular(4),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                otp = verificationCode;
                print(verificationCode);
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 79,
              ),
              child: Center(
                child: SizedBox(
                  width: 95,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        print('-------------------------');
                        print(otp);
                        bool a = await widget.authService.verifySmsCode(
                          otp,
                        );
                        print(smsController.toString());
                        if (a == true) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: 'OTP not verified ',
                              fontSize: 12.0,
                              backgroundColor: AppColors.redDelete,
                              timeInSecForIosWeb: 3,
                              textColor: AppColors.descColor);
                        }
                      },
                      child: const Text(
                        'VERIFY',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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
