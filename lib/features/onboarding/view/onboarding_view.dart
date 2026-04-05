import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controller/onboarding_controller.dart';
import '../../../core/theme/app_theme.dart';
import 'dart:ui';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final numberController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Stack(
        children: [
          // Background Glow Orbs for High-Tech feel
          Positioned(top: -100, right: -100, child: _buildGlowOrb(200, AppTheme.primaryColor.withOpacity(0.05))),
          Positioned(bottom: -50, left: -50, child: _buildGlowOrb(150, AppTheme.secondaryColor.withOpacity(0.05))),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(controller),
                    const SizedBox(height: 30),
                    _buildHeader().animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                    const SizedBox(height: 40),
                    _buildScanningManifest(controller).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                    const SizedBox(height: 30),
                    Obx(() => controller.isFinished.value 
                      ? _buildPhoneInputPhase(controller, numberController).animate().fadeIn().scale(begin: const Offset(0.9, 0.9))
                      : _buildScanPhase(controller)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]),
    );
  }

  Widget _buildStepIndicator(OnboardingController controller) {
    return Obx(() => Row(
      children: [
        _stepDot(true),
        _stepDivider(controller.isFinished.value),
        _stepDot(controller.isFinished.value),
      ],
    ));
  }

  Widget _stepDot(bool active) {
    return AnimatedContainer(
      duration: 300.ms,
      width: 12, height: 12,
      decoration: BoxDecoration(
        color: active ? AppTheme.primaryColor : Colors.white12,
        shape: BoxShape.circle,
        boxShadow: active ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.5), blurRadius: 10)] : null,
      ),
    );
  }

  Widget _stepDivider(bool active) {
    return Expanded(child: Container(height: 1, color: active ? AppTheme.primaryColor.withOpacity(0.3) : Colors.white12));
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("NODE_INITIALIZATION", style: TextStyle(color: AppTheme.primaryColor, letterSpacing: 4, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        const Text("WELCOME_OPERATOR", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
        const SizedBox(height: 12),
        const Text("CONFIGURE_YOUR_SMS_GATEWAY_NODE", style: TextStyle(color: Colors.white30, letterSpacing: 1, fontSize: 11)),
      ],
    );
  }

  Widget _buildScanningManifest(OnboardingController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark.withOpacity(0.4),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.radar, size: 14, color: AppTheme.primaryColor),
                  SizedBox(width: 10),
                  Text("HARDWARE_MANIFEST_SCAN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 25),
              Obx(() => _permissionStatusRow("SMS_PROTOCOL", controller.smsStatus.value)),
              const SizedBox(height: 18),
              Obx(() => _permissionStatusRow("CELLULAR_STATE", controller.phoneStatus.value)),
              const SizedBox(height: 18),
              Obx(() => _permissionStatusRow("GEO_LOCATION_BEACON", controller.locationStatus.value)),
              const SizedBox(height: 18),
              Obx(() => _permissionStatusRow("PERSISTENCE_LAYER", controller.batteryStatus.value, optional: true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _permissionStatusRow(String title, bool isReady, {bool optional = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(border: Border.all(color: isReady ? AppTheme.primaryColor : Colors.white10), shape: BoxShape.circle),
          child: Icon(isReady ? Icons.check : Icons.close, size: 10, color: isReady ? AppTheme.primaryColor : Colors.white24),
        ),
        const SizedBox(width: 15),
        Expanded(child: Text(title, style: TextStyle(color: isReady ? Colors.white : Colors.white38, fontSize: 12, letterSpacing: 1.5))),
        if (isReady) 
           const Text(" [READY]", style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold))
        else if (optional)
           const Text(" [SKIP]", style: TextStyle(color: Colors.white10, fontSize: 10))
        else
           const Text(" [PENDING]", style: TextStyle(color: Colors.white24, fontSize: 10, fontStyle: FontStyle.italic)),
      ],
    );
  }

  Widget _buildScanPhase(OnboardingController controller) {
    return Column(
      children: [
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.requestAll(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: controller.isLoading.value 
              ? const CircularProgressIndicator(color: AppTheme.primaryColor, strokeWidth: 1.5)
              : const Text("INITIALIZE_INTERFACE_SCAN", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3)),
          )),
        ),
      ],
    );
  }

  Widget _buildPhoneInputPhase(OnboardingController controller, TextEditingController numberController) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("TARGET_UPLINK_NODE", style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 20),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 6, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "000-000-0000",
                  hintStyle: const TextStyle(color: Colors.white12, fontSize: 18),
                  prefixIcon: const Icon(Icons.emergency_share, color: AppTheme.primaryColor),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Text("DATA_BEACONS_WILL_BE_TRANSMITTED_TO_THIS_ID", style: TextStyle(fontSize: 9, color: Colors.white24, letterSpacing: 1)),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              if (numberController.text.length >= 10) {
                controller.saveUserPhone(numberController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 10,
              shadowColor: AppTheme.primaryColor.withOpacity(0.4),
            ),
            child: const Text("ESTABLISH_UPLINK", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4)),
          ),
        ),
      ],
    );
  }
}
