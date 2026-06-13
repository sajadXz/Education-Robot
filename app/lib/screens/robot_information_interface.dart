import 'package:flutter/material.dart';
import 'profile_interface.dart';
import '../localization/app_text.dart';

class RobotInformationInterface extends StatefulWidget {
  const RobotInformationInterface({super.key});

  @override
  State<RobotInformationInterface> createState() =>
      _RobotInformationInterfaceState();
}

class _RobotInformationInterfaceState extends State<RobotInformationInterface> {
  bool speech = false;
  bool reading = false;
  bool stories = false;
  bool world = false;

  final TextEditingController hoursController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.get("robotInfo")), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF264B96),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  AppText.get("robotInfo"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _sectionTitle(AppText.get("educationalSubjects")),

                    CheckboxListTile(
                      value: speech,
                      title: Text(AppText.get("speechLearning")),
                      onChanged: (value) {
                        setState(() {
                          speech = value!;
                        });
                      },
                    ),

                    CheckboxListTile(
                      value: reading,
                      title: Text(AppText.get("readingLearning")),
                      onChanged: (value) {
                        setState(() {
                          reading = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    _sectionTitle(AppText.get("entertainmentSubjects")),

                    CheckboxListTile(
                      value: stories,
                      title: Text(AppText.get("storyListening")),
                      onChanged: (value) {
                        setState(() {
                          stories = value!;
                        });
                      },
                    ),

                    CheckboxListTile(
                      value: world,
                      title: Text(AppText.get("worldKnowledge")),
                      onChanged: (value) {
                        setState(() {
                          world = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(AppText.get("robotWorkingHours")),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "0",
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(AppText.get("notes")),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: AppText.get("addInstructions"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 220,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileInterface(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF264B96),
                  foregroundColor: Colors.white,
                ),
                child: Text(AppText.get("continue")),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
