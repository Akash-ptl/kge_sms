import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/hardware_container.dart';
import '../controller/sms_controller.dart';

class SMSTestingPanel extends StatefulWidget {
  final SMSController controller;
  const SMSTestingPanel({super.key, required this.controller});

  @override
  State<SMSTestingPanel> createState() => _SMSTestingPanelState();
}

class _SMSTestingPanelState extends State<SMSTestingPanel> {
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HardwareContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TRANSMISSION_TESTLOADER", style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _numberController,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: "ENTER_VISITOR_NUMBER",
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderColor)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
              filled: true,
              fillColor: AppTheme.darkBg,
              prefixIcon: const Icon(Icons.phone_android, size: 16, color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_numberController.text.isNotEmpty) {
                  await widget.controller.sendTestSms(_numberController.text);
                  _numberController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text("EXECUTE_TEST_SIGNAL", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
