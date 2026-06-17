import 'package:flutter/material.dart';
import '../localization/app_text.dart';
import '../widgets/bottom_nav.dart';

import 'profile_interface.dart';
import 'rewards_interface.dart';
import 'alerts_interface.dart';

class LearningInterface extends StatefulWidget {
  const LearningInterface({super.key});

  @override
  State<LearningInterface> createState() => _LearningInterfaceState();
}

class _LearningInterfaceState extends State<LearningInterface> {
  int selectedCategory = 0;

  void navigateTo(int index) {
    if (index == 0) return;

    Widget page;

    switch (index) {
      case 1:
        page = const RewardsInterface();
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

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(centerTitle: true, title: Text(AppText.get("learning"))),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).cardColor
                    : const Color(0xFFBFEFFF),

                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  Image.asset("assets/images/robot_lesson.png", height: 130),

                  const SizedBox(height: 15),

                  Text(
                    AppText.get("spaceExplorerMission"),

                    style: const TextStyle(
                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text("75% Complete"),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: const LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 12,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: () {},

                    child: Text(AppText.get("resumeLesson")),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              AppText.get("categories"),

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  _categoryButton(AppText.get("allLessons"), 0),

                  _categoryButton(AppText.get("mathMagic"), 1),

                  _categoryButton(AppText.get("wordPlay"), 2),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              AppText.get("newChallenges"),

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            _lessonCard(
              image: "ImagesRobot/mMath.png",

              title: AppText.get("countingCatch"),

              subtitle: AppText.get("math"),
            ),

            _lessonCard(
              image: "ImagesRobot/puzzle_paths.png",

              title: AppText.get("puzzlePaths"),

              subtitle: AppText.get("logic"),
            ),

            _lessonCard(
              image: "ImagesRobot/story_time.png",

              title: AppText.get("storyTime"),

              subtitle: AppText.get("reading"),
            ),

            _lockedLessonCard(),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(currentIndex: 0, onTap: navigateTo),
    );
  }

  Widget _categoryButton(String title, int index) {
    final selected = selectedCategory == index;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = index;
          });
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? Theme.of(context).colorScheme.primary
              : null,
        ),

        child: Text(title),
      ),
    );
  }

  Widget _lessonCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: Theme.of(context).cardColor,

      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        leading: Image.asset(image, width: 60, height: 60),

        title: Text(title),

        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget _lockedLessonCard() {
    return Card(
      color: Theme.of(context).cardColor,

      child: ListTile(
        leading: const Icon(Icons.lock, size: 40, color: Colors.grey),

        title: Text(AppText.get("blockBuilder")),

        subtitle: Text(AppText.get("completeMoreLessons")),
      ),
    );
  }
}
