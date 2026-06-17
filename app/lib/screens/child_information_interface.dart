import 'package:flutter/material.dart';
import 'parent_information_interface.dart';
import '../localization/app_text.dart';

class ChildInformationInterface extends StatefulWidget {
  const ChildInformationInterface({super.key});

  @override
  State<ChildInformationInterface> createState() =>
      _ChildInformationInterfaceState();
}

class _ChildInformationInterfaceState extends State<ChildInformationInterface> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController wakeController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController likesController = TextEditingController();
  final TextEditingController dislikesController = TextEditingController();
  final TextEditingController fearsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String gender = "Male";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppText.get("childInfo"))),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// صورة البروفايل
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 22,
                backgroundImage: const AssetImage("assets/images/profile.png"),
                backgroundColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            /// عنوان معلومات الطفل
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF264B96),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                AppText.get("childInfo"),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// الصورة العلوية
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "ImagesRobot/rob_boy.png",
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            _label(AppText.get("name")),
            _field(controller: nameController, hint: AppText.get("childName")),

            const SizedBox(height: 15),

            _label(AppText.get("gender")),

            DropdownButtonFormField<String>(
              value: gender,
              decoration: _inputDecoration(),
              items: [
                DropdownMenuItem(
                  value: "Male",
                  child: Text(AppText.get("male")),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text(AppText.get("female")),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            _label(AppText.get("age")),
            _field(controller: ageController, hint: "5"),

            const SizedBox(height: 15),

            _label(AppText.get("birthDate")),
            _field(controller: birthDateController, hint: "mm/dd/yyyy"),

            const SizedBox(height: 15),

            _label(AppText.get("schoolGrade")),
            _field(controller: gradeController, hint: "مثال: الصف الأول"),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _label(AppText.get("wakeUpTime")),
                      _field(controller: wakeController, hint: "--:--"),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    children: [
                      _label(AppText.get("sleepTime")),
                      _field(controller: sleepController, hint: "--:--"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _label(AppText.get("likes")),
            _field(
              controller: likesController,
              hint: "الألعاب، الهوايات...",
              maxLines: 3,
            ),

            const SizedBox(height: 15),

            _label(AppText.get("dislikes")),
            _field(
              controller: dislikesController,
              hint: "الأكلات، الأصوات...",
              maxLines: 3,
            ),

            const SizedBox(height: 15),

            _label(AppText.get("fears")),
            _field(controller: fearsController, hint: "مثال: الظلام"),

            const SizedBox(height: 15),

            _label(AppText.get("notes")),
            _field(
              controller: notesController,
              hint: "أي معلومات إضافية تود مشاركتها",
              maxLines: 4,
            ),

            const SizedBox(height: 25),

            /// الصورة السفلية
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "ImagesRobot/rob_n.png",
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
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
                              const ParentInformationInterface(),
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
                      backgroundColor: const Color(0xFFB8D7F3),
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

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration([String? hint]) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
