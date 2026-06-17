import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../localization/app_text.dart';
import 'learning_interface.dart';
import 'rewards_interface.dart';
import 'alerts_interface.dart';
import 'settings_interface.dart';

class ProfileInterface extends StatefulWidget {
  const ProfileInterface({super.key});

  @override
  State<ProfileInterface> createState() => _ProfileInterfaceState();
}

class _ProfileInterfaceState extends State<ProfileInterface> {
  void navigateTo(int index) {
    if (index == 2) return;

    Widget page;

    switch (index) {
      case 0:
        page = const LearningInterface();
        break;

      case 1:
        page = const RewardsInterface();
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  children: [
                    Icon(
                      Icons.smart_toy,

                      color: isDark ? Colors.white : const Color(0xFF006A96),

                      size: 35,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "Robot Pal",

                      style: TextStyle(
                        fontSize: 28,

                        fontWeight: FontWeight.bold,

                        color: isDark ? Colors.white : const Color(0xFF006A96),
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      icon: Icon(
                        Icons.settings,

                        color: isDark ? Colors.white : const Color(0xFF006A96),

                        size: 30,
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const SettingsInterface(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).cardColor
                      : const Color(0xFFDDF2FA),

                  borderRadius: BorderRadius.circular(35),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.15),

                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 85,

                      backgroundImage: const AssetImage(
                        "assets/images/profile_child.png",
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Leo Explorador",

                      style: TextStyle(
                        fontSize: 34,

                        fontWeight: FontWeight.bold,

                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color: const Color.fromARGB(28, 178, 235, 242),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(AppText.get("spaceFan")),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color: const Color.fromARGB(48, 253, 249, 2),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(AppText.get("mathWhiz")),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.white70,

                              borderRadius: BorderRadius.circular(25),
                            ),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 40,
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "1240",

                                  style: TextStyle(
                                    fontSize: 30,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(AppText.get("stars")),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.white70,

                              borderRadius: BorderRadius.circular(25),
                            ),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.teal,
                                  size: 40,
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "14",

                                  style: TextStyle(
                                    fontSize: 30,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(AppText.get("dayStreak")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).cardColor
                      : const Color(0xFFDDF2FA),

                  borderRadius: BorderRadius.circular(35),
                ),

                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,

                      backgroundColor: Color(0xFF12A6E4),

                      child: Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                        size: 55,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      AppText.get("robotOnline"),

                      style: const TextStyle(
                        fontSize: 28,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: 0.82,

                      minHeight: 14,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,

                      child: Text("${AppText.get("batteryLevel")} 82%"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              const Icon(
                Icons.admin_panel_settings,
                size: 70,
                color: Colors.grey,
              ),

              const SizedBox(height: 20),

              Text(
                AppText.get("grownUpsOnly"),

                style: const TextStyle(
                  fontSize: 34,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),

                child: Text(
                  AppText.get("parentZoneDescription"),

                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: 300,
                height: 60,

                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppText.get("parentZoneComingSoon")),
                      ),
                    );
                  },

                  icon: const Icon(Icons.lock),

                  label: Text(AppText.get("enterParentZone")),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNav(currentIndex: 2, onTap: navigateTo),
    );
  }
}
