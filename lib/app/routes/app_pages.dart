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
import '../modules/messagerie/bindings/messagerie_binding.dart';
import '../modules/messagerie/views/messagerie_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile_detail/bindings/profile_detail_binding.dart';
import '../modules/profile_detail/views/profile_detail_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register_main/bindings/register_main_binding.dart';
import '../modules/register_main/views/register_main_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
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
    GetPage(
      name: _Paths.PROFILE_DETAIL,
      page: () => const ProfileDetailView(),
      binding: ProfileDetailBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_MAIN,
      page: () => const RegisterMainView(),
      binding: RegisterMainBinding(),
    ),
    // GetPage(
    //   name: _Paths.MESSAGERIE,
    //   page: () => const MessagerieView(),
    //   binding: MessagerieBinding(),
    // ),
  ];
}
