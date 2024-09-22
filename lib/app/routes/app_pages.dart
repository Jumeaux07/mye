import 'package:get/get.dart';

import '../modules/MainIntro/bindings/main_intro_binding.dart';
import '../modules/MainIntro/views/main_intro_view.dart';
import '../modules/Profileregister/bindings/profileregister_binding.dart';
import '../modules/Profileregister/views/profileregister_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN_INTRO;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_INTRO,
      page: () => const MainIntroView(),
      binding: MainIntroBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    // GetPage(
    //   name: _Paths.OTP,
    //   page: () =>   OtpView(),
    //   binding: OtpBinding(),
    // ),
    GetPage(
      name: _Paths.PROFILEREGISTER,
      page: () => const ProfileregisterView(),
      binding: ProfileregisterBinding(),
    ),
  ];
}
