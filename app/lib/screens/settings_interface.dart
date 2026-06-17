import 'package:flutter/material.dart';
import '../main.dart';
import '../localization/app_text.dart';
import 'parent_login_interface.dart';
import 'edit_child_interface.dart';
import 'edit_parent_interface.dart';
import 'edit_robot_settings_interface.dart';

class SettingsInterface extends StatefulWidget {
  const SettingsInterface({super.key});

  @override
  State<SettingsInterface> createState() => _SettingsInterfaceState();
}

class _SettingsInterfaceState extends State<SettingsInterface> {
  int selectedTheme = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F9FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        backgroundColor: const Color(0xFF0D6EFD),

        foregroundColor: Colors.white,

        title: Text(AppText.isArabic ? "الإعدادات" : "Settings"),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.settings),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [
            _settingsCard(
              icon: Icons.language,
              iconColor: Colors.blue,

              title: AppText.isArabic ? "اللغة" : "Language",

              subtitle: AppText.isArabic
                  ? "اختر لغة التطبيق"
                  : "Choose App Language",

              trailing: DropdownButton<String>(
                value: AppText.isArabic ? "العربية" : "English",

                underline: const SizedBox(),

                items: const [
                  DropdownMenuItem(value: "العربية", child: Text("العربية")),
                  DropdownMenuItem(value: "English", child: Text("English")),
                ],

                onChanged: (value) {
                  MyApp.of(context).changeLanguage(value == "العربية");

                  setState(() {});
                },
              ),
            ),

            _settingsCard(
              icon: Icons.dark_mode,
              iconColor: Colors.amber,

              title: AppText.isArabic ? "الوضع" : "Theme",

              subtitle: AppText.isArabic
                  ? "اختر الوضع الفاتح أو الداكن"
                  : "Choose Light Or Dark Mode",

              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,

                onChanged: (value) {
                  MyApp.of(context).toggleTheme();
                },
              ),
            ),

            _tileButton(
              Icons.child_care,
              Colors.blue,
              AppText.get("editChildInfo"),
              AppText.get("editChildInfoDesc"),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditChildInterface(),
                  ),
                );
              },
            ),

            _tileButton(
              Icons.people,
              Colors.blue,
              AppText.get("editParentInfo"),
              AppText.get("editParentInfoDesc"),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditParentInterface(),
                  ),
                );
              },
            ),

            _tileButton(
              Icons.smart_toy,
              Colors.teal,
              AppText.get("robotSettings"),
              AppText.get("robotSettingsDesc"),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditRobotSettingsInterface(),
                  ),
                );
              },
            ),

            _tileButton(
              Icons.logout,
              Colors.red,
              AppText.get("logout"),
              AppText.get("logoutDesc"),
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParentLoginInterface(),
                  ),
                  (route) => false,
                );
              },
            ),

            _tileButton(
              Icons.account_circle,
              Colors.purple,
              AppText.get("switchAccount"),
              AppText.get("switchAccountDesc"),
              () {},
            ),

            _tileButton(
              Icons.bar_chart,
              Colors.teal,
              AppText.get("robotEvaluation"),
              AppText.get("robotEvaluationDesc"),
              () {},
            ),

            _tileButton(
              Icons.help,
              Colors.blue,
              AppText.get("help"),
              AppText.get("helpDesc"),
              () {},
            ),

            _tileButton(
              Icons.smart_toy_outlined,
              Colors.indigo,
              AppText.get("robotGuide"),
              AppText.get("robotGuideDesc"),
              () {},
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  const Icon(Icons.smart_toy, size: 50, color: Colors.blue),

                  const SizedBox(height: 10),

                  Text(
                    AppText.get("robotDescription"),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${AppText.get("version")} 1.0.0",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Card(
      color: Theme.of(context).cardColor,

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,

          child: Icon(icon, color: iconColor),
        ),

        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }

  Widget _tileButton(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      color: Theme.of(context).cardColor,

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,

          child: Icon(icon, color: color),
        ),

        title: Text(title),
        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _themeColor(int index, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTheme = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selectedTheme == index
              ? Border.all(color: Colors.black, width: 3)
              : null,
        ),
      ),
    );
  }
}
