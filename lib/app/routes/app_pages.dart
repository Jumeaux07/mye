import 'package:get/get.dart';

import '../modules/Login/bindings/login_binding.dart';
import '../modules/Login/views/login_view.dart';
import '../modules/MainIntro/bindings/main_intro_binding.dart';
import '../modules/MainIntro/views/main_intro_view.dart';
import '../modules/Profileregister/bindings/profileregister_binding.dart';
import '../modules/Profileregister/views/profileregister_view.dart';
import '../modules/abonnement/bindings/abonnement_binding.dart';
import '../modules/abonnement/views/abonnement_view.dart';
import '../modules/cinetpay/bindings/cinetpay_binding.dart';
import '../modules/cinetpay/views/cinetpay_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/interrestprofil/bindings/interrestprofil_binding.dart';
import '../modules/interrestprofil/views/interrestprofil_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

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
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.INTERRESTPROFIL,
      page: () => const InterrestprofilView(),
      binding: InterrestprofilBinding(),
    ),
    GetPage(
      name: _Paths.ABONNEMENT,
      page: () => AbonnementView(),
      binding: AbonnementBinding(),
    ),
    GetPage(
      name: _Paths.CINETPAY,
      page: () => const CinetpayView(),
      binding: CinetpayBinding(),
    ),
  ];
}
