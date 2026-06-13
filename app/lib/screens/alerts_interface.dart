import 'package:flutter/material.dart';

import '../localization/app_text.dart';
import '../widgets/bottom_nav.dart';

import 'learning_interface.dart';
import 'rewards_interface.dart';
import 'profile_interface.dart';

class AlertsInterface extends StatefulWidget {
  const AlertsInterface({super.key});

  @override
  State<AlertsInterface> createState() => _AlertsInterfaceState();
}

class _AlertsInterfaceState extends State<AlertsInterface> {
  bool hasAlerts = true;

  void navigateTo(int index) {
    Widget page;

    switch (index) {
      case 0:
        page = const LearningInterface();
        break;

      case 1:
        page = const RewardsInterface();
        break;

      case 2:
        page = const ProfileInterface();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(centerTitle: true, title: Text(AppText.get("alerts"))),

      body: hasAlerts ? _alertsBody() : _emptyAlerts(),

      bottomNavigationBar: BottomNav(currentIndex: 3, onTap: navigateTo),
    );
  }

  Widget _alertsBody() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _alertCard(
          icon: Icons.school,
          title: AppText.get("newLessonAvailable"),
          description: AppText.get("newLessonDesc"),
        ),

        _alertCard(
          icon: Icons.battery_alert,
          title: AppText.get("robotBatteryLow"),
          description: AppText.get("robotBatteryDesc"),
        ),

        _alertCard(
          icon: Icons.bar_chart,
          title: AppText.get("weeklyProgressReport"),
          description: AppText.get("weeklyProgressDesc"),
        ),
      ],
    );
  }

  Widget _emptyAlerts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/sleep_robot.png", height: 180),

            const SizedBox(height: 25),

            Text(
              AppText.get("allCaughtUp"),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text(AppText.get("robotResting"), textAlign: TextAlign.center),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {},

              child: Text(AppText.get("checkAgain")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alertCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),

        title: Text(title),

        subtitle: Text(description),
      ),
    );
  }
}
