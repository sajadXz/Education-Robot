import 'package:flutter/material.dart';
import 'robot_information_interface.dart';
import '../localization/app_text.dart';

class ParentInformationInterface extends StatefulWidget {
  const ParentInformationInterface({super.key});

  @override
  State<ParentInformationInterface> createState() =>
      _ParentInformationInterfaceState();
}

class _ParentInformationInterfaceState
    extends State<ParentInformationInterface> {
  final fatherNameController = TextEditingController();
  final fatherEmailController = TextEditingController();
  final fatherAgeController = TextEditingController();
  final fatherPhoneController = TextEditingController();

  final motherNameController = TextEditingController();
  final motherEmailController = TextEditingController();
  final motherAgeController = TextEditingController();
  final motherPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("روبوتيتي"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            /// صورة العائلة
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "ImagesRobot/img_family.png",
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            /// بيانات الأب
            _sectionTitle(AppText.get("fatherInfo")),

            const SizedBox(height: 15),

            _field(
              controller: fatherNameController,
              label: AppText.get("fullName"),
            ),

            const SizedBox(height: 12),

            _field(
              controller: fatherEmailController,
              label: AppText.get("email"),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: fatherAgeController,
                    label: AppText.get("age"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                    controller: fatherPhoneController,
                    label: AppText.get("phoneNumber"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// بيانات الأم
            _sectionTitle(AppText.get("motherInfo")),

            const SizedBox(height: 15),

            _field(
              controller: motherNameController,
              label: AppText.get("fullName"),
            ),

            const SizedBox(height: 12),

            _field(
              controller: motherEmailController,
              label: AppText.get("email"),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: motherAgeController,
                    label: AppText.get("age"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                    controller: motherPhoneController,
                    label: AppText.get("phoneNumber"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Icon(
              Icons.family_restroom,
              size: 50,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RobotInformationInterface(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF264B96),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 55),
                    ),
                    child: Text(AppText.get("next")),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5D9FF),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(0, 55),
                    ),
                    child: Text(AppText.get("cancel")),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF264B96),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
