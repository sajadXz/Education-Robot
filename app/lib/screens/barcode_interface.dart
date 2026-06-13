import 'package:flutter/material.dart';

import '../localization/app_text.dart';

class BarcodeInterface extends StatelessWidget {
  const BarcodeInterface({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppText.get("linkRobot"),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),

              // مربع الباركود
              Container(
                width: size.width * 0.78,
                height: size.width * 0.78,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade900
                      : const Color(0xFFDCECF6),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: Center(
                  child: Image.asset(
                    "ImagesRobot/barcode.png",
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // صورة الروبوت
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.grey.shade800
                      : const Color(0xFFDCECF6),
                ),
                child: ClipOval(
                  child: Image.asset(
                    "ImagesRobot/barcode.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Text(
                AppText.get("scanDescription"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // سنربط الكاميرا لاحقاً
                  },
                  child: Text(
                    AppText.get("openCamera"),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {},
                child: Text(
                  AppText.get("cantFindCode"),
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
