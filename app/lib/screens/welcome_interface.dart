import 'package:flutter/material.dart';
import 'barcode_interface.dart';
import 'parent_login_interface.dart';
import '../constants/app_images.dart';
import '../localization/app_text.dart';
import '../main.dart';

class WelcomeInterface extends StatefulWidget {
  const WelcomeInterface({super.key});

  @override
  State<WelcomeInterface> createState() => _WelcomeInterfaceState();
}

class _WelcomeInterfaceState extends State<WelcomeInterface> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      MyApp.of(context).toggleTheme();
                    },
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  ),

                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        AppText.isArabic = !AppText.isArabic;
                      });
                    },
                    icon: const Icon(Icons.language),
                    label: Text(AppText.isArabic ? "English" : "العربية"),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.02),

              Container(
                width: size.width * 0.50,
                height: size.width * 0.50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: Image.asset(AppImages.robot, fit: BoxFit.cover),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Text(
                AppText.get("hi"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Robot Pal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006A96),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Text(
                AppText.get("description"),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BarcodeInterface(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8CF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    AppText.get("getStarted"),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParentLoginInterface(),
                    ),
                  );
                },
                child: Text(
                  AppText.get("parentsLogin"),
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
