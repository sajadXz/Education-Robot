import 'package:flutter/material.dart';

import '../localization/app_text.dart';
import '../widgets/bottom_nav.dart';

import 'learning_interface.dart';
import 'profile_interface.dart';
import 'alerts_interface.dart';

class RewardsInterface extends StatefulWidget {
  const RewardsInterface({super.key});

  @override
  State<RewardsInterface> createState() => _RewardsInterfaceState();
}

class _RewardsInterfaceState extends State<RewardsInterface> {
  void navigateTo(int index) {
    Widget page;

    switch (index) {
      case 0:
        page = const LearningInterface();
        break;

      case 2:
        page = const ProfileInterface();
        break;

      case 3:
        page = const AlertsInterface();
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

      appBar: AppBar(centerTitle: true, title: Text(AppText.get("rewards"))),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: const Color(0xFFBFEFFF),

                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  Image.asset("assets/images/rewards_robot.png", height: 120),

                  const SizedBox(height: 15),

                  Text(
                    AppText.get("myStarCoins"),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "1240 ⭐",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            Text(
              AppText.get("trophyRoom"),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _trophyCard(
                    Icons.menu_book,
                    AppText.get("readingStar"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _trophyCard(
                    Icons.rocket_launch,
                    AppText.get("spaceExplorer"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(child: _lockedCard()),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              AppText.get("unlockRobotFun"),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            _rewardItem(
              image: "assets/images/robot_dance.png",
              title: AppText.get("robotDance"),
            ),

            _rewardItem(
              image: "assets/images/new_paint.png",
              title: AppText.get("newPaint"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(currentIndex: 1, onTap: navigateTo),
    );
  }

  Widget _trophyCard(IconData icon, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, size: 45, color: Colors.amber),

            const SizedBox(height: 10),

            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _lockedCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(Icons.lock, size: 45, color: Colors.grey),

            SizedBox(height: 10),

            Text("???"),
          ],
        ),
      ),
    );
  }

  Widget _rewardItem({required String image, required String title}) {
    return Card(
      child: ListTile(
        leading: Image.asset(image, width: 60, height: 60),

        title: Text(title),

        trailing: ElevatedButton(
          onPressed: () {},

          child: Text(AppText.get("unlock")),
        ),
      ),
    );
  }
}
