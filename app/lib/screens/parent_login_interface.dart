import 'package:flutter/material.dart';
import 'child_information_interface.dart';
import '../localization/app_text.dart';
import '../auth_service.dart';

class ParentLoginInterface extends StatelessWidget {
  const ParentLoginInterface({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan.withValues(alpha: 0.2),
                ),
              ),
            ),

            Positioned(
              bottom: -120,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan.withValues(alpha: 0.2),
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: size.width * .88,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.asset(
                            "ImagesRobot/robot11.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        AppText.get("welcomeBack"),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006A96),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        AppText.get("readyAdventure"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.apple),
                          label: Text(AppText.get("continueApple")),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            "ImagesRobot/Google.png",
                            width: 24,
                          ),
                          label: Text(AppText.get("continueGoogle")),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(AppText.get("or")),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChildInformationInterface(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.email_outlined),
                          label: Text(AppText.get("emailLogin")),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005F87),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppText.get("noAccount")),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF006A96),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _feature(
                            Icons.security,
                            AppText.get("secureEncrypted"),
                          ),
                          _feature(
                            Icons.verified,
                            AppText.get("coppaCompliant"),
                          ),
                          _feature(
                            Icons.family_restroom,
                            AppText.get("parentalControls"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feature(IconData icon, String text) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Icon(icon, color: Colors.teal, size: 30),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
