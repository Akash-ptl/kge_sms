import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingController extends GetxController {
  final smsStatus = false.obs;
  final phoneStatus = false.obs;
  final locationStatus = false.obs;
  final batteryStatus = false.obs;
  final isFinished = false.obs;

  final userPhone = "".obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatuses();
  }

  Future<void> _checkInitialStatuses() async {
    smsStatus.value = await Permission.sms.isGranted;
    phoneStatus.value = await Permission.phone.isGranted;
    locationStatus.value = await Permission.location.isGranted;
    batteryStatus.value = await Permission.ignoreBatteryOptimizations.isGranted;
    _updateFinishStatus();
  }

  void _updateFinishStatus() {
    isFinished.value = smsStatus.value && phoneStatus.value && locationStatus.value;
  }

  Future<void> requestAll() async {
    isLoading.value = true;
    
    // Serial request for a "Scanning" effect in UI
    await Permission.sms.request();
    smsStatus.value = await Permission.sms.isGranted;
    await Future.delayed(const Duration(milliseconds: 500));

    await Permission.phone.request();
    phoneStatus.value = await Permission.phone.isGranted;
    await Future.delayed(const Duration(milliseconds: 500));

    await Permission.location.request();
    locationStatus.value = await Permission.location.isGranted;
    await Future.delayed(const Duration(milliseconds: 500));

    // Optional but good for background service
    await Permission.ignoreBatteryOptimizations.request();
    batteryStatus.value = await Permission.ignoreBatteryOptimizations.isGranted;

    _updateFinishStatus();
    isLoading.value = false;
  }

  Future<void> saveUserPhone(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', number);
    userPhone.value = number;
    Get.offAllNamed('/dashboard');
  }
}
