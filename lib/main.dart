import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:sms/Home/messages.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SMS',
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
            builder: (context) =>
                // MyHomePage(
                //   simCard: _simCard,
                // )
                MessageList(
                  simCard: _simCard,
                )
            // MyHomePage(
            //   simCard: _simCard,
            // )
            ),
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
