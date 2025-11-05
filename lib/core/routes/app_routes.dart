import 'package:assignment/feature/file_uploader/bindings/home_binding.dart';
import 'package:assignment/feature/file_uploader/view/home_screen.dart';
import 'package:assignment/feature/splash_screen/view/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static String get initialRoute => splashScreen;

  static String splashScreen = "/splash-screen";
  static String homeScreen = "/home";

  static List<GetPage<dynamic>> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen(), binding: HomeBinding()),
  ];
}
