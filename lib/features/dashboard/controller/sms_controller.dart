import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_sim_data/sim_data.dart';
import 'package:flutter_sim_data/sim_data_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../../Model/get_smb_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../global.dart';
import 'dart:io';

class SMSController extends GetxController {
  final logger = Logger();
  final isRunning = false.obs;
  final lastSync = DateTime.now().obs;
  final messages = <SmsRow>[].obs;
  
  // SIM Data
  final simCards = <SimDataModel>[].obs;
  final isHardwareReady = false.obs;

  // Stats
  final sentCount = 0.obs;
  final failedCount = 0.obs;
  final totalCount = 0.obs;

  // Interval Settings
  final isIntervalEnabled = false.obs;
  final intervalMinutes = 1.obs;
  Timer? _beaconTimer;
  String? _userTargetPhone;

  @override
  void onInit() {
    super.onInit();
    _fetchHardwareDetails();
    _loadUserConfig();
    _loadDummyData();
  }

  Future<void> _fetchHardwareDetails() async {
    if (Platform.isAndroid) {
      try {
        final data = await SimData().getSimData();
        simCards.assignAll(data);
        isHardwareReady.value = simCards.isNotEmpty;
        logger.i("Hardware Manifest: Detected ${simCards.length} SIM nodes.");
      } catch (e) {
        logger.w("Hardware Error: $e");
      }
    }
  }

  Future<void> _loadUserConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _userTargetPhone = prefs.getString('user_phone');
    isRunning.value = prefs.getBool('node_running') ?? false;
    isIntervalEnabled.value = true; // Tracking is now the primary task
    intervalMinutes.value = prefs.getInt('interval_minutes') ?? 1;
    
    if (isRunning.value) _startBeaconTimer();
  }

  void _loadDummyData() {
    messages.assignAll([
      SmsRow(
        uuid: 'KGE-NODE-BOOT',
        senderid: 'SYS_ENGINE',
        receiverid: _userTargetPhone ?? "9328895180",
        msgtext: 'KGE_GATEWAY: Hardware initialization successful. Tracking protocol active.',
        type: 'SYSTEM',
        sent: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        result: 'DELIVERED',
        status: 'SENT'
      ),
      SmsRow(
        uuid: 'REAL-LOC-01',
        senderid: 'BEACON_NODE',
        receiverid: _userTargetPhone ?? "9328895180",
        msgtext: 'NODE_BEACON [LAT: 23.0225, LONG: 72.5714] (Gujarat, India). Transmission successful.',
        type: 'GPS_UPDATE',
        sent: DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
        result: 'SUCCESS',
        status: 'SENT'
      ),
    ]);
    _calculateStats();
  }

  void _calculateStats() {
    sentCount.value = messages.where((m) => m.result == 'DELIVERED' || m.result == 'SUCCESS').length;
    failedCount.value = messages.where((m) => m.result == 'FAILED' || m.result == 'ERROR').length;
    totalCount.value = messages.length;
  }

  Future<void> toggleService([bool? forceValue]) async {
    isRunning.value = forceValue ?? !isRunning.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('node_running', isRunning.value);
    
    if (isRunning.value) {
      logger.i("Portfolio SMS Gateway Started");
      _startBeaconTimer();
    } else {
      logger.w("Portfolio SMS Gateway Stopped");
      _beaconTimer?.cancel();
    }
  }

  // Tracking is now managed via toggleService. We can still toggle frequency.
  void setTrackingInterval(int mins) async {
    intervalMinutes.value = mins;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('interval_minutes', mins);
    if (isRunning.value) {
      _startBeaconTimer(); // Restart with new interval
    }
  }

  void _startBeaconTimer() {
    _beaconTimer?.cancel();
    _beaconTimer = Timer.periodic(Duration(minutes: intervalMinutes.value), (timer) {
      if (isRunning.value) syncNow();
    });
  }

  Future<void> syncNow() async {
    lastSync.value = DateTime.now();
    Get.snackbar("BEACON_TRANSMITTING", "Fetching node location & syncing...", 
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      colorText: AppTheme.primaryColor,
      duration: const Duration(seconds: 2),
    );

    String locMsg = "KGE_BEACON: Lat: UNKNOWN, Lon: UNKNOWN";
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      locMsg = "KGE_BEACON: Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
    } catch (e) {
      logger.e("GPS Error: $e");
    }

    if (isRunning.value && simCards.isNotEmpty && _userTargetPhone != null) {
      await _sendSmsNow(_userTargetPhone!, locMsg);
      messages.insert(0, SmsRow(
        uuid: 'LOC-${DateTime.now().millisecond}',
        senderid: 'BEACON_NODE',
        receiverid: _userTargetPhone!,
        msgtext: locMsg,
        type: 'GPS_UPDATE',
        sent: DateTime.now().toIso8601String(),
        result: 'SUCCESS',
        status: 'SENT'
      ));
    }
    _calculateStats();
  }

  Future<void> sendTestSms(String number) async {
    bool wasOff = !isRunning.value;
    if (wasOff) {
      await toggleService(true);
    }

    Get.snackbar("TEST_SIGNAL", "EXECUTING_TRANSMISSION_PROTOCOL...", 
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      colorText: AppTheme.primaryColor,
      duration: const Duration(seconds: 3),
    );

    await _sendSmsNow(number, "KGE_TEST_LOG: Transmission successful from Portfolio Node.");
    messages.insert(0, SmsRow(
      uuid: 'TEST-X-${DateTime.now().millisecond}',
      senderid: 'TEST_LAB',
      receiverid: number,
      msgtext: 'Manual Test Transmission: SUCCESS',
      type: 'TEST',
      sent: DateTime.now().toIso8601String(),
      result: 'DELIVERED',
      status: 'SENT'
    ));
    _calculateStats();
  }

  Future<void> _sendSmsNow(String number, String message) async {
    try {
      await Constants.nativeChannel.invokeMethod("sendSMS", {
        "mobileNumber": number,
        "message": message,
        "subscriptionId": simCards[0].subscriptionId.toString(),
      });
      logger.i("SMS_SENT_TO: $number");
    } catch (e) {
      logger.e("TRANSMISSION_FAILED: $e");
    }
  }

  @override
  void onClose() {
    _beaconTimer?.cancel();
    super.onClose();
  }
}
