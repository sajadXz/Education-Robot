import 'package:flutter/material.dart';
import '../localization/app_text.dart';

class EditRobotSettingsInterface extends StatefulWidget {
  const EditRobotSettingsInterface({super.key});

  @override
  State<EditRobotSettingsInterface> createState() =>
      _EditRobotSettingsInterfaceState();
}

class _EditRobotSettingsInterfaceState
    extends State<EditRobotSettingsInterface> {
  bool speechLearning = true;
  bool readingLearning = true;

  bool storyListening = false;
  bool worldKnowledge = true;

  TimeOfDay workingHours = const TimeOfDay(hour: 2, minute: 0);

  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F9FC),

      appBar: AppBar(
        centerTitle: true,

        title: Text(AppText.get("robotSettings")),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF29488F),

                borderRadius: BorderRadius.circular(25),
              ),

              child: Center(
                child: Text(
                  AppText.get("robotSettings"),

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 22,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle(AppText.get("educationalPrograms"), Icons.school),

            _checkTile(AppText.get("speechLearning"), speechLearning, (v) {
              setState(() {
                speechLearning = v!;
              });
            }),

            _checkTile(AppText.get("readingLearning"), readingLearning, (v) {
              setState(() {
                readingLearning = v!;
              });
            }),
            const SizedBox(height: 20),

            _sectionTitle(
              AppText.get("entertainmentPrograms"),
              Icons.celebration,
            ),

            _checkTile(AppText.get("storyListening"), storyListening, (v) {
              setState(() {
                storyListening = v!;
              });
            }),

            _checkTile(AppText.get("worldKnowledge"), worldKnowledge, (v) {
              setState(() {
                worldKnowledge = v!;
              });
            }),

            const SizedBox(height: 25),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.blue),

                title: Text(AppText.get("robotHours")),

                subtitle: Text(workingHours.format(context)),

                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: workingHours,
                  );

                  if (picked != null) {
                    setState(() {
                      workingHours = picked;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: notesController,

              maxLines: 5,

              decoration: InputDecoration(
                labelText: AppText.get("notes"),

                prefixIcon: const Icon(Icons.notes),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF29488F),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppText.get("savedSuccessfully"))),
                  );
                },

                child: Text(AppText.get("saveChanges")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _checkTile(String title, bool value, Function(bool?) onChanged) {
    return Card(
      child: CheckboxListTile(
        value: value,

        title: Text(title),

        onChanged: onChanged,
      ),
    );
  }
}
