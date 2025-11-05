import 'package:assignment/core/constants/app_color.dart';
import 'package:assignment/core/constants/assets_utils.dart';
import 'package:assignment/core/routes/app_routes.dart';
import 'package:assignment/feature/file_uploader/bindings/home_binding.dart';
import 'package:assignment/feature/file_uploader/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.homeScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(
        child: Image.asset(
          AssetsUtils.splashScreenImage,
          width: 100,
          height: 100,
        )
      ),
    );
  }
}
