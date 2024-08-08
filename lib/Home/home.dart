import 'dart:convert';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sim_data/sim_model.dart';
import 'package:sms/Home/sign_up.dart';
import 'package:sms/utils/const.dart';

import '../Widget/custom_box.dart';
import '../Widget/myTextField.dart';
import '../global.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.simCard});

  final List<SimCard> simCard;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool start = false;

  @override
  void initState() {
    super.initState();
  }

  final Logger logger = Logger();
  TextEditingController phoneController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  RxString selectedCountryCode = '91'.obs;
  final selectedCountryFlag = ValueNotifier('🇮🇳');

  Cron? cron;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'SMS App',
            style: TextStyle(fontFamily: 'helvetica', color: Colors.white),
          ),
          centerTitle: true,
          // leading: Image.network(
          //     'https://raw.githubusercontent.com/kgetechnologies/kgesitecdn/kgetechnologies-com/images/KgeMain.png'),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            children: [
              4.ph,
              CustomFirstTextField(
                heading: "Pincode *",
                hintText: "Enter Username",
                controller: msgController,
              ),
              3.ph,
              CustomFirstTextField(
                heading: "Pincode *",
                hintText: "Enter Password",
                controller: msgController,
              ),
              4.ph,
              GestureDetector(
                onTap: () {
                  // Get.to(NavigationScreen(simCard: []));
                },
                child: CustomContainer(
                    height: h * 0.05,
                    color: Colors.blue,
                    borderRadius: h * 0.01,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              2.ph,
              GestureDetector(
                onTap: () {
                  Get.to(SignUpScreen());
                },
                child: CustomContainer(
                    height: h * 0.05,
                    color: Colors.blue,
                    borderRadius: h * 0.01,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> sendSms() async {
  //   String phoneNumber = '9328895180';
  //   String message = 'KGE Technologies';
  //
  //   if (Platform.isAndroid) {
  //     await Constants.nativeChannel.invokeMethod("sendSMS", {
  //       "mobileNumber": phoneNumber,
  //       "message": message,
  //       "subscriptionId": widget.simCard[0].subscriptionId.toString(),
  //     });
  //   }
  //   Map<String, dynamic> smsData = {
  //     'phoneNumber': phoneNumber,
  //     'message': message,
  //     'sim': widget.simCard[0].subscriptionId.toString()
  //   };
  //   String jsonEncoded = json.encode(smsData);
  //   print(jsonEncoded);
  // }
  Future<void> sendSms() async {
    FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard

    await Future.delayed(const Duration(milliseconds: 100));
    String phoneNumber = phoneController.text;
    String message = msgController.text;

    try {
      if (Platform.isAndroid) {
        await Constants.nativeChannel.invokeMethod("sendSMS", {
          "mobileNumber": phoneNumber,
          "message": message,
          "subscriptionId": widget.simCard[0].subscriptionId.toString(),
        });
      }
      Map<String, dynamic> smsData = {
        'phoneNumber': phoneNumber,
        'message': message,
        'sim': widget.simCard[0].subscriptionId.toString()
      };
      String jsonEncoded = json.encode(smsData);
      print(jsonEncoded);

      // Show a success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SMS sent successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending SMS: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
