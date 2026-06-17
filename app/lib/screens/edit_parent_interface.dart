import 'package:flutter/material.dart';
import '../localization/app_text.dart';

class EditParentInterface extends StatefulWidget {
  const EditParentInterface({super.key});

  @override
  State<EditParentInterface> createState() => _EditParentInterfaceState();
}

class _EditParentInterfaceState extends State<EditParentInterface> {
  final fatherNameController = TextEditingController();

  final fatherJobController = TextEditingController();

  final fatherPhoneController = TextEditingController();

  final motherNameController = TextEditingController();

  final motherJobController = TextEditingController();

  final motherPhoneController = TextEditingController();

  bool fatherHasJob = true;
  bool motherHasJob = true;

  TimeOfDay fatherWorkTime = const TimeOfDay(hour: 8, minute: 0);

  TimeOfDay motherWorkTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F9FC),

      appBar: AppBar(
        centerTitle: true,

        title: Text(AppText.get("editParentInfo")),
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

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Image.asset(
                  "assets/images/family.png",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle(AppText.get("fatherInfo"), Icons.man, Colors.blue),

            _field(
              controller: fatherNameController,

              icon: Icons.person,

              label: AppText.get("fatherName"),
            ),

            SwitchListTile(
              value: fatherHasJob,

              title: Text(AppText.get("hasJob")),

              secondary: const Icon(Icons.work),

              onChanged: (value) {
                setState(() {
                  fatherHasJob = value;
                });
              },
            ),

            _field(
              controller: fatherJobController,

              icon: Icons.badge,

              label: AppText.get("jobType"),
            ),

            _field(
              controller: fatherPhoneController,

              icon: Icons.phone,

              label: AppText.get("fatherPhone"),
            ),
            _timeCard(
              AppText.get("fatherWorkHours"),
              fatherWorkTime,
              Icons.access_time,
              true,
            ),

            const SizedBox(height: 25),

            _sectionTitle(
              AppText.get("motherInfo"),
              Icons.woman,
              Colors.purple,
            ),

            _field(
              controller: motherNameController,

              icon: Icons.person,

              label: AppText.get("motherName"),
            ),

            SwitchListTile(
              value: motherHasJob,

              title: Text(AppText.get("hasJob")),

              secondary: const Icon(Icons.work),

              onChanged: (value) {
                setState(() {
                  motherHasJob = value;
                });
              },
            ),

            _field(
              controller: motherJobController,

              icon: Icons.badge,

              label: AppText.get("jobType"),
            ),

            _field(
              controller: motherPhoneController,

              icon: Icons.phone,

              label: AppText.get("motherPhone"),
            ),
            _timeCard(
              AppText.get("motherWorkHours"),
              motherWorkTime,
              Icons.access_time,
              false,
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Row(
        children: [
          Icon(icon, color: color, size: 30),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _timeCard(String title, TimeOfDay time, IconData icon, bool father) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),

        title: Text(title),

        subtitle: Text(time.format(context)),

        trailing: const Icon(Icons.edit),

        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: time,
          );

          if (picked != null) {
            setState(() {
              if (father) {
                fatherWorkTime = picked;
              } else {
                motherWorkTime = picked;
              }
            });
          }
        },
      ),
    );
  }
}
