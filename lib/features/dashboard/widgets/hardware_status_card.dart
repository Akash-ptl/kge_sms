import 'package:flutter/material.dart';
import '../../../core/widgets/hardware_container.dart';
import 'package:flutter_sim_data/sim_data_model.dart';
import '../../../core/theme/app_theme.dart';

class HardwareStatusCard extends StatelessWidget {
  final List<SimDataModel> simCards;
  const HardwareStatusCard({super.key, required this.simCards});

  @override
  Widget build(BuildContext context) {
    return HardwareContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("HARDWARE_MANIFEST", style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildDetailRow("PERMISSIONS", "GRNTD", AppTheme.primaryColor),
          const Divider(color: AppTheme.borderColor, height: 20),
          if (simCards.isEmpty)
            const Text("NO_SIM_DETECTED", style: TextStyle(color: Colors.redAccent, fontSize: 12))
          else
            ...simCards.map((sim) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildDetailRow(
                "SIM_ID_${sim.subscriptionId}", 
                sim.displayName?.toUpperCase() ?? 'UNKNOWN', 
                AppTheme.secondaryColor
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
        Text(value, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
      ],
    );
  }
}
