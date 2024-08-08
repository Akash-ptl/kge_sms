import 'package:cron/cron.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sms/utils/const.dart';

import '../Widget/custom_box.dart';
import '../Widget/myTextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool start = false;

  @override
  void initState() {
    super.initState();
    get();
  }

  Future<void> get() async {
    print('androidDeviceInfo.androidId :: ');
    androidDeviceInfo = await deviceInfo.androidInfo;
    print('androidDeviceInfo.androidId :: ${androidDeviceInfo?.device}');
  }

  final Logger logger = Logger();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController sim1Controller = TextEditingController();
  TextEditingController simController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxString selectedCountryCode = '91'.obs;
  final selectedCountryFlag = ValueNotifier('🇮🇳');
  String _selectedValue = 'Select Sim 1\nCarrier';
  String _selectedValue1 = 'Select Sim 2\nCarrier';
  Cron? cron;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidDeviceInfo;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          // title: const Text(
          //   'Sign Up',
          //   style: TextStyle(fontFamily: 'helvetica', color: Colors.white),
          // ),
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
                hintText: "Enter FullName",
                controller: userNameController,
              ),
              3.ph,
              CustomFirstTextField(
                heading: "Password *",
                hintText: "Enter Password",
                controller: passwordController,
              ),
              3.ph,
              CustomFirstTextField(
                heading: "Password *",
                hintText: "Enter Email",
                controller: emailController,
              ),
              3.ph,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(w * 0.02),
                          border: Border.all()),
                      child: Padding(
                        padding: EdgeInsets.only(left: w * 0.04),
                        child: DropdownButton<String>(
                          value: _selectedValue,
                          icon: const SizedBox(),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: const SizedBox(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue = newValue!;
                            });
                            print('Selected value: $newValue');
                          },
                          items: <String>[
                            'Select Sim 1\nCarrier',
                            'Option 2',
                            'Option 3',
                            'Option 4',
                            'Option 5',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  1.5.pw,
                  Expanded(
                    flex: 2,
                    child: CustomFirstTextField(
                      heading: "Password *",
                      hintText: "Enter Number 1",
                      controller: phoneController,
                    ),
                  ),
                ],
              ),
              3.ph,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(w * 0.02),
                          border: Border.all()),
                      width: w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                        child: DropdownButton<String>(
                          value: _selectedValue1,
                          icon: const SizedBox(),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: const SizedBox(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue1 = newValue!;
                            });
                            print('Selected value: $newValue');
                          },
                          items: <String>[
                            'Select Sim 2\nCarrier',
                            'Option 2',
                            'Option 3',
                            'Option 4',
                            'Option 5',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  1.5.pw,
                  Expanded(
                    flex: 2,
                    child: CustomFirstTextField(
                      heading: "Password *",
                      hintText: "Enter Number 2",
                      controller: phone1Controller,
                    ),
                  ),
                ],
              ),
              4.ph,
              GestureDetector(
                onTap: () {
                  get();

                  final body = {
                    'apipoint': 'smbadd',
                    'UserName': userNameController.text,
                    'Password': passwordController.text,
                    'UUID': '1234568',
                    'SENDERID': phoneController.text,
                    'RECEIVERID': phoneController.text,
                    'MSGTEXT':
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                    'TYPE': '1',
                    'DEVICEID': '${androidDeviceInfo?.device}',
                  };
                  // SMSApi.addSMB(body);
                },
                child: CustomContainer(
                    height: h * 0.05,
                    color: Colors.blue,
                    borderRadius: h * 0.01,
                    child: const Text(
                      'Add',
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
}
