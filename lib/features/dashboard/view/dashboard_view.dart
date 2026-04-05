import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/sms_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/circuit_background.dart';
import '../../../core/widgets/hardware_container.dart';
import '../widgets/hardware_status_card.dart';
import '../widgets/sms_test_panel.dart';
import '../widgets/interval_settings_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SMSController()); // SimCards fetched inside controller now

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: const Text("KGE_GATEWAY_NODE_v2"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
            return CircuitBackground(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isWide 
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildSystemStatus(controller),
                              const SizedBox(height: 20),
                              _buildStatsBar(controller, isWide: true),
                              const SizedBox(height: 20),
                              _buildLogHeader(),
                              const SizedBox(height: 10),
                              Expanded(child: _buildLogList(controller)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Obx(() {
                                  controller.simCards.length; // Observe list changes
                                  return HardwareStatusCard(simCards: controller.simCards);
                                }),
                                const SizedBox(height: 20),
                                IntervalSettingsCard(controller: controller),
                                const SizedBox(height: 20),
                                SMSTestingPanel(controller: controller),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _buildSystemStatus(controller)),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(child: _buildStatsBar(controller, isWide: false)),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(child: Obx(() {
                          controller.simCards.length; // Observe list changes
                          return HardwareStatusCard(simCards: controller.simCards);
                        })),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(child: IntervalSettingsCard(controller: controller)),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(child: SMSTestingPanel(controller: controller)),
                        const SliverToBoxAdapter(child: SizedBox(height: 30)),
                        SliverToBoxAdapter(child: _buildLogHeader()),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: _buildLogList(controller),
                        ),
                      ],
                    ),
              ),
            );
        },
      ),
    );
  }

  Widget _buildSystemStatus(SMSController controller) {
    return HardwareContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildPulsingDot(),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              "MONITORING_READY: OPERATIONAL_NODE", 
              style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.5)
            )
          ),
          Obx(() => Switch(
            value: controller.isRunning.value,
            onChanged: (v) => controller.toggleService(),
            activeColor: AppTheme.primaryColor,
          )),
        ],
      ),
    );
  }

  Widget _buildPulsingDot() {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryColor,
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.5), blurRadius: 4, spreadRadius: 2)],
      ),
    );
  }

  Widget _buildStatsBar(SMSController controller, {required bool isWide}) {
    return Obx(() {
      final items = [
        _buildStatItem("TX_OK", controller.sentCount.value.toString(), AppTheme.primaryColor),
        if (!isWide) _buildDivider(),
        _buildStatItem("TX_FAIL", controller.failedCount.value.toString(), Colors.redAccent),
        if (!isWide) _buildDivider(),
        _buildStatItem("QUEUE", controller.totalCount.value.toString(), AppTheme.secondaryColor),
      ];

      return HardwareContainer(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(children: items),
      );
    });
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white38)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: AppTheme.borderColor);
  }

  Widget _buildLogHeader() {
    return Row(
      children: [
        Container(height: 1, width: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 10),
        const Text("LIVE_TRANSMISSION_LOG", style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, letterSpacing: 2)),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: AppTheme.borderColor)),
      ],
    );
  }

  Widget _buildLogList(SMSController controller) {
    return Obx(() => ListView.builder(
          itemCount: controller.messages.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final msg = controller.messages[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HardwareContainer(
                padding: const EdgeInsets.all(12),
                accentColor: _getStatusColor(msg.result ?? ""),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("NOD_ID: ${(msg.uuid ?? "N/A").length > 8 ? msg.uuid!.substring(0, 8) : (msg.uuid ?? "N/A")}", style: const TextStyle(fontSize: 10, color: Colors.blueAccent)),
                        Text((msg.sent ?? "").length >= 16 ? msg.sent!.substring(11, 16) : "--:--", style: const TextStyle(fontSize: 10, color: Colors.white24)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(msg.msgtext ?? "", style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.white70)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildTerminalBadge(msg.result ?? "UNKNOWN"),
                        const Spacer(),
                        const Icon(Icons.hub, size: 12, color: Colors.white30),
                        Text(" ${msg.receiverid}", style: const TextStyle(fontSize: 10, color: Colors.white30)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _buildTerminalBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.5))),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }

  Color _getStatusColor(String status) {
    if (status == "DELIVERED" || status == "SUCCESS") return AppTheme.primaryColor;
    if (status == "FAILED" || status == "ERROR") return Colors.redAccent;
    return Colors.amberAccent;
  }

}
