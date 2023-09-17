import 'package:flutter/material.dart';
import 'package:seda_driver/src/models/vehicle_company_type.dart';
import 'package:seda_driver/src/models/vehicle_type.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/screens/auth/login_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/otp_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/basic_info_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/car_license_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/certificate_of_good_conduct_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/customer_support_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/driver_license_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/national_id_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/number_plate_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/obtain_criminal_record_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/vehicle_brand_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/vehicle_color_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/vehicle_model_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register/vehicle_photo_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/register_screen.dart';
import 'package:seda_driver/src/presentation/screens/auth/success_screen.dart';
import 'package:seda_driver/src/presentation/screens/chat_screen.dart';
import 'package:seda_driver/src/presentation/screens/city_to_city_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/earning_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/history_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/invite_friends_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/levels_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/notifications_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/privacy_policy_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/profile_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/request_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/subscriptions_screen.dart';
import 'package:seda_driver/src/presentation/screens/drawer/wallet_screen.dart';
import 'package:seda_driver/src/presentation/screens/history_details_screen.dart';
import 'package:seda_driver/src/presentation/screens/home_screen.dart';
import 'package:seda_driver/src/presentation/screens/how_to_use_screen.dart';
import 'package:seda_driver/src/presentation/screens/reservation_of_hour_screen.dart';
import 'package:seda_driver/src/presentation/screens/shared/no_internet_screen.dart';
import 'package:seda_driver/src/presentation/screens/shared/splash_screen.dart';
import 'package:seda_driver/src/presentation/screens/shared/terms_and_condition_screen.dart';
import 'package:seda_driver/src/presentation/screens/subscriptions_type_screen.dart';

import '../../models/order_model.dart';
import '../../models/response/subscription/subscription.dart';
import '../screens/drawer/points_screen.dart';

Route<dynamic>? appRouter(RouteSettings settings) {
  switch (settings.name) {
    case AppRouterNames.splash:
      return MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      );
    case AppRouterNames.login:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      );
    case AppRouterNames.otp:
      final String phone = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => OtpScreen(
          phone: phone,
        ),
      );
    case AppRouterNames.register:
      return MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      );
    case AppRouterNames.basicInfo:
      return MaterialPageRoute(
        builder: (_) => const BasicInfoScreen(),
      );
    case AppRouterNames.driverLicense:
      return MaterialPageRoute(
        builder: (_) => const DriverLicenseScreen(),
      );
    case AppRouterNames.carLicense:
      return MaterialPageRoute(
        builder: (_) => const CarLicenseScreen(),
      );
    case AppRouterNames.certificateOfGoodConduct:
      return MaterialPageRoute(
        builder: (_) => const CertificateOfGoodConductScreen(),
      );
    case AppRouterNames.nationalId:
      return MaterialPageRoute(
        builder: (_) => const NationalIdScreen(),
      );
    case AppRouterNames.termsAndConditions:
      return MaterialPageRoute(
        builder: (_) => const TermsAndConditionScreen(),
      );
    case AppRouterNames.privacyPolicy:
      return MaterialPageRoute(
        builder: (_) => const PrivacyPolicyScreen(),
      );
    case AppRouterNames.customerSupport:
      return MaterialPageRoute(
        builder: (_) => const CustomerSupportScreen(),
      );
    case AppRouterNames.obtainCriminalRecord:
      return MaterialPageRoute(
        builder: (_) => const ObtainCriminalRecordScreen(),
      );
    case AppRouterNames.vehicleBrand:
      return MaterialPageRoute(
        builder: (_) => const VehicleBrandScreen(),
      );
    case AppRouterNames.vehicleColor:
      final args = settings.arguments as List;
      final VehicleType vehicleType = args[0] as VehicleType;
      final VehicleCompanyType vehicleCompanyType =
          args[1] as VehicleCompanyType;
      return MaterialPageRoute(
        builder: (_) => VehicleColorScreen(
          vehicleType: vehicleType,
          vehicleCompanyType: vehicleCompanyType,
        ),
      );
    case AppRouterNames.vehicleModel:
      final VehicleType vehicleType = settings.arguments as VehicleType;
      return MaterialPageRoute(
        builder: (_) => VehicleModelScreen(
          vehicleType: vehicleType,
        ),
      );
    case AppRouterNames.vehiclePhoto:
      return MaterialPageRoute(
        builder: (_) => const VehiclePhotoScreen(),
      );
    case AppRouterNames.numberPlate:
      return MaterialPageRoute(
        builder: (_) => const NumberPlateScreen(),
      );
    case AppRouterNames.home:
      final orderModel = settings.arguments as OrderModel?;
      return MaterialPageRoute(
        builder: (_) => HomeScreen(
          orderModel: orderModel,
        ),
      );
    case AppRouterNames.notifications:
      return MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      );
    case AppRouterNames.request:
      return MaterialPageRoute(
        builder: (_) => const RequestScreen(),
      );
    case AppRouterNames.history:
      return MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
      );
    case AppRouterNames.wallet:
      return MaterialPageRoute(
        builder: (_) => const WalletScreen(),
      );
    case AppRouterNames.earning:
      return MaterialPageRoute(
        builder: (_) => const EarningScreen(),
      );
    case AppRouterNames.levels:
      return MaterialPageRoute(
        builder: (_) => const LevelsScreen(),
      );
    case AppRouterNames.points:
      return MaterialPageRoute(
        builder: (_) => const PointsScreen(),
      );
    case AppRouterNames.inviteFriends:
      return MaterialPageRoute(
        builder: (_) => const InviteFriendsScreen(),
      );
    case AppRouterNames.subscriptions:
      return MaterialPageRoute(
        builder: (_) => const SubscriptionsScreen(),
      );
    case AppRouterNames.profile:
      return MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      );
    case AppRouterNames.howToUse:
      return MaterialPageRoute(
        builder: (_) => const HowToUseScreen(),
      );
    case AppRouterNames.historyDetails:
      return MaterialPageRoute(
        builder: (_) => const HistoryDetailsScreen(),
      );
    case AppRouterNames.subscriptionsType:
      final data = settings.arguments as Map<String, dynamic>;
      final subscription = data['subscription'] as Subscription;
      return MaterialPageRoute(
        builder: (_) => SubscriptionsTypeScreen(
          subscription: subscription,
        ),
      );
    case AppRouterNames.cityToCity:
      return MaterialPageRoute(
        builder: (_) => const CityToCityScreen(),
      );
    case AppRouterNames.reservationOfHour:
      return MaterialPageRoute(
        builder: (_) => const ReservationOfHourScreen(),
      );
    case AppRouterNames.chat:
      return MaterialPageRoute(
        builder: (_) => const ChatScreen(),
      );
    case AppRouterNames.noInternet:
      return MaterialPageRoute(
        builder: (_) => const NoInternetScreen(),
      );
    case AppRouterNames.success:
      return MaterialPageRoute(
        builder: (_) => const SuccessScreen(),
      );
    default:
      return null;
  }
}
