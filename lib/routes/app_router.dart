import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
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
import 'package:krishi_mitra/features/3_crop_diagnosis/presentation/screens/crop_upload_screen.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/presentation/screens/processing_screen.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/presentation/screens/result_screen.dart';
import 'package:krishi_mitra/features/4_crop_history/presentation/screens/crop_history_screen.dart';
import 'package:krishi_mitra/features/4_crop_history/presentation/screens/crop_history_detail_screen.dart';

// Provider for GoRouter with authentication awareness
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.success;
      final isLoading = authState.status == AuthStatus.loading;
      final currentPath = state.matchedLocation;
      
      // Protected routes that require authentication
      final protectedRoutes = [
        '/home',
        '/scan',
        '/disease-detection',
        '/prices',
        '/market-prices',
        '/crops',
        '/weather',
        '/crop-upload',
        '/crop-processing',
        '/crop-result',
        '/history',
      ];
      
      // Public routes that authenticated users shouldn't access
      final publicRoutes = [
        '/phone-input',
        '/otp',
        '/language-selection',
      ];
      
      final isProtectedRoute = protectedRoutes.contains(currentPath) || 
                               currentPath.startsWith('/history/');
      final isPublicRoute = publicRoutes.contains(currentPath);
      
      // If on splash screen and authenticated, redirect to home
      if (currentPath == '/' && isAuthenticated) {
        return '/home';
      }
      
      // If authenticated and trying to access public routes, redirect to home
      if (isAuthenticated && isPublicRoute) {
        return '/home';
      }
      
      // If not authenticated and trying to access protected route, redirect to phone input
      if (!isAuthenticated && !isLoading && isProtectedRoute) {
        return '/phone-input';
      }
      
      // No redirect needed
      return null;
    },
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
      builder: (context, state) => const CropUploadScreen(),
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
    GoRoute(
      path: '/crop-upload',
      builder: (context, state) => const CropUploadScreen(),
    ),
    GoRoute(
      path: '/crop-processing',
      builder: (context, state) => const ProcessingScreen(),
    ),
    GoRoute(
      path: '/crop-result',
      builder: (context, state) {
        final result = state.extra;
        return ResultScreen(result: result as dynamic);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const CropHistoryScreen(),
    ),
    GoRoute(
      path: '/history/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CropHistoryDetailScreen(submissionId: id);
      },
    ),
  ],
  );
});

// Legacy export for backward compatibility
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
      builder: (context, state) => const CropUploadScreen(),
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
    GoRoute(
      path: '/crop-upload',
      builder: (context, state) => const CropUploadScreen(),
    ),
    GoRoute(
      path: '/crop-processing',
      builder: (context, state) => const ProcessingScreen(),
    ),
    GoRoute(
      path: '/crop-result',
      builder: (context, state) {
        final result = state.extra;
        return ResultScreen(result: result as dynamic);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const CropHistoryScreen(),
    ),
    GoRoute(
      path: '/history/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CropHistoryDetailScreen(submissionId: id);
      },
    ),
  ],
);
