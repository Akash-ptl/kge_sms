import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms/global.dart';
import 'package:sim_data/sim_data.dart';
import 'package:cron/cron.dart';
import 'package:logger/logger.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PermissionHandlerScreen(),
    );
  }
}

class PermissionHandlerScreen extends StatefulWidget {
  const PermissionHandlerScreen({super.key});

  @override
  _PermissionHandlerScreenState createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  List<SimCard> _simCard = <SimCard>[];
  @override
  void initState() {
    super.initState();
    permissionServiceCall();
  }

  permissionServiceCall() async {
    await permissionServices().then(
      (value) async {
        if (value[Permission.phone]!.isGranted) {
          await _getSimCards();
        }
      },
    );
  }

  Future<void> _getSimCards() async {
    if (Platform.isAndroid) {
      final SimData simData = await SimDataPlugin.getSimData();
      _simCard = simData.cards;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  simCard: _simCard,
                )),
      );
    }
  }

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.sms, Permission.phone].request();

    if (statuses[Permission.sms]!.isPermanentlyDenied) {
      openAppSettings();
    } else {
      if (statuses[Permission.sms]!.isDenied) {
        permissionServiceCall();
      }
    }
    if (statuses[Permission.phone]!.isPermanentlyDenied) {
      openAppSettings();
    } else {
      if (statuses[Permission.phone]!.isDenied) {
        permissionServiceCall();
      }
    }
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: Center(
          child: InkWell(
              onTap: () {
                permissionServiceCall();
              },
              child: const Text("Click on Allow all the time")),
        ),
      ),
    );
  }
}

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

  Cron? cron;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {});
            start = !start;

            if (start == true) {
              logger.d('Start');
            } else {
              logger.d('Stop');
            }
            if (start == true) {
              cron = Cron();
              cron!.schedule(Schedule.parse('*/1 * * * *'), () {
                print(DateTime.now());
                sendSms();
              });
            } else {
              cron!.close();
              cron = null;
            }
          },
          child: (start == false)
              ? const Icon(Icons.send)
              : const Icon(Icons.stop),
        ),
        appBar: AppBar(
          title: const Text(
            'KGE Technologies',
            style: TextStyle(fontFamily: 'helvetica'),
          ),
          centerTitle: true,
          // leading: Image.network(
          //     'https://raw.githubusercontent.com/kgetechnologies/kgesitecdn/kgetechnologies-com/images/KgeMain.png'),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<void> sendSms() async {
    String phoneNumber = '9328895180';
    String message = 'KGE Technologies';

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
  }
}
