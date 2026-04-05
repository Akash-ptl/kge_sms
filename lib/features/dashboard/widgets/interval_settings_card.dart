import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/hardware_container.dart';
import '../controller/sms_controller.dart';

class IntervalSettingsCard extends StatelessWidget {
  final SMSController controller;
  const IntervalSettingsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => HardwareContainer(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AUTO_LOCATION_BEACON (MODE_ACTIVE)", style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TRANSMISSION_FREQUENCY", style: TextStyle(fontSize: 10, color: Colors.white30)),
                    Text("${controller.intervalMinutes.value} MIN", style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                  ),
                  child: Slider(
                    value: controller.intervalMinutes.value.toDouble(),
                    min: 1,
                    max: 60,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.borderColor,
                    onChanged: (v) => controller.setTrackingInterval(v.toInt()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
