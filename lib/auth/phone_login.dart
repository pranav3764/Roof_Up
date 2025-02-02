import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roof_up/Common/TextField.dart';
import 'otp.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}
class _PhoneLoginState extends State<PhoneLogin> {
  final _phoneController = TextEditingController();

  void _verifyPhoneNumber() async {
    final phoneNumber = _phoneController.text;
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number')),
      );
    } else if (phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid phone number')),
      );
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${_phoneController.text.toString()}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          // Handle failure
          print('Failed to verify phone number: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => otppage(
                phoneNumber: _phoneController.text,
                verificationId: verificationId,
              )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  // void _navigateToOtpPage() {
  //   final phoneNumber = _phoneController.text;
  //
  //   if (phoneNumber.isEmpty) {
  //     // Show error if phone number is empty
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please enter a phone number')),
  //     );
  //   } else if (phoneNumber.length < 10) {
  //     // Show error if phone number is less than 10 digits
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please enter a valid phone number')),
  //     );
  //   } else {
  //     // Navigate to the OTP page if the phone number is valid
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => otppage(phoneNumber: phoneNumber),
  //       ),
  //     );
  //   }
  // }

  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),

                Center(
                  child: Image.asset('assets/images/otp.png',
                    height: MediaQuery.of(context).size.height*0.35,),
                ),

                SizedBox(height: 30),

                Text('OTP Verification',
                  style:TextStyle(
                    fontSize:20,
                    fontFamily: GoogleFonts.kanit().fontFamily
                  )
                ),
                Text('Enter phone number for OTP',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white60,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.blue.shade800,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade400)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue.shade800)
                        )
                    ),
                  ),
                ),

                SizedBox(height: 20),

                CustomButton(name: 'Continue', onpressed: (){
                  // _navigateToOtpPage();
                  _verifyPhoneNumber();
                }),

                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
