import 'package:go_router/go_router.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/crop_analysis_screen.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/crop_diagnosis_screen.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/create_account_screen.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/disease_detection_screen.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/onboarding.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/otp_verification_screen.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/phone_input_screen.dart';
import 'package:krishi_mitra/features/1_auth/presentation/screens/splash_screen.dart';
import 'package:krishi_mitra/features/2_home/presentation/screens/home_screen.dart';
import 'package:krishi_mitra/features/2_home/presentation/screens/mandi_prices_screen.dart';
import 'package:krishi_mitra/features/2_home/presentation/screens/market_prices_screen.dart';
import 'package:krishi_mitra/features/2_home/presentation/screens/my_crops_screen.dart';
import 'package:krishi_mitra/features/2_home/presentation/screens/weather_details_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/phone-input',
      builder: (context, state) => const PhoneInputScreen(),
    ),
    GoRoute(
      path: '/language-selection',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phoneNumber = state.extra as String?;
        return OtpVerificationScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/scan',
      builder: (context, state) => const CropDiagnosisScreen(),
    ),
    GoRoute(
      path: '/crop-analysis',
      builder: (context, state) => const CropAnalysisScreen(),
    ),
    GoRoute(
      path: '/disease-detection',
      builder: (context, state) => const DiseaseDetectionScreen(),
    ),
    GoRoute(
      path: '/prices',
      builder: (context, state) => const MandiPricesScreen(),
    ),
    GoRoute(
      path: '/market-prices',
      builder: (context, state) => const MarketPricesScreen(),
    ),
    GoRoute(
      path: '/crops',
      builder: (context, state) => const MyCropsScreen(),
    ),
    GoRoute(
      path: '/weather',
      builder: (context, state) => const WeatherDetailsScreen(),
    ),
  ],
);
