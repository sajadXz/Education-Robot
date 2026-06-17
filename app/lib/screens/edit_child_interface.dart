import 'package:flutter/material.dart';
import '../localization/app_text.dart';

class EditChildInterface extends StatefulWidget {
  const EditChildInterface({super.key});

  @override
  State<EditChildInterface> createState() => _EditChildInterfaceState();
}

class _EditChildInterfaceState extends State<EditChildInterface> {
  final nameController = TextEditingController();

  final schoolController = TextEditingController();

  final likesController = TextEditingController();

  final dislikesController = TextEditingController();

  final fearsController = TextEditingController();

  final notesController = TextEditingController();

  String gender = "Boy";

  DateTime? selectedBirthDate;

  TimeOfDay sleepTime = const TimeOfDay(hour: 21, minute: 0);

  TimeOfDay wakeTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F9FC),

      appBar: AppBar(
        centerTitle: true,

        title: Text(AppText.get("editChildInfo")),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,

                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          "assets/images/profile_child.png",
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: CircleAvatar(
                          backgroundColor: Colors.blue,

                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),

                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  TextButton.icon(
                    onPressed: () {},

                    icon: const Icon(Icons.edit),

                    label: Text(AppText.get("changePhoto")),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _field(
              controller: nameController,

              icon: Icons.child_care,

              label: AppText.get("childName"),
            ),

            _dropdownGender(),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month, color: Colors.blue),

                title: Text(AppText.get("birthDate")),

                subtitle: Text(
                  selectedBirthDate == null
                      ? "dd/mm/yyyy"
                      : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
                ),

                trailing: const Icon(Icons.edit, color: Colors.blue),

                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,

                    initialDate: DateTime.now(),

                    firstDate: DateTime(2010),

                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedBirthDate = picked;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            _field(
              controller: schoolController,

              icon: Icons.school,

              label: AppText.get("schoolStage"),
            ),

            _timeCard(AppText.get("sleepTime"), sleepTime, Icons.nightlight),

            _timeCard(AppText.get("wakeTime"), wakeTime, Icons.wb_sunny),
            _field(
              controller: likesController,

              icon: Icons.favorite,

              label: AppText.get("likes"),

              maxLines: 3,
            ),

            _field(
              controller: dislikesController,

              icon: Icons.heart_broken,

              label: AppText.get("dislikes"),

              maxLines: 3,
            ),

            _field(
              controller: fearsController,

              icon: Icons.warning,

              label: AppText.get("fears"),
            ),

            _field(
              controller: notesController,

              icon: Icons.description,

              label: AppText.get("additionalNotes"),

              maxLines: 4,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
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

  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextField(
        controller: controller,
        maxLines: maxLines,

        decoration: InputDecoration(
          prefixIcon: Icon(icon),

          labelText: label,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _dropdownGender() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: DropdownButtonFormField<String>(
        value: gender,

        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.people),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),

        items: [
          DropdownMenuItem(value: "Boy", child: Text(AppText.get("boy"))),
          DropdownMenuItem(value: "Girl", child: Text(AppText.get("girl"))),
        ],

        onChanged: (value) {
          setState(() {
            gender = value!;
          });
        },
      ),
    );
  }

  Widget _timeCard(String title, TimeOfDay time, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),

        title: Text(title),

        subtitle: Text(time.format(context)),

        trailing: const Icon(Icons.edit, color: Colors.blue),

        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: time,
          );

          if (picked != null) {
            setState(() {
              if (title == AppText.get("sleepTime")) {
                sleepTime = picked;
              } else {
                wakeTime = picked;
              }
            });
          }
        },
      ),
    );
  }
}
