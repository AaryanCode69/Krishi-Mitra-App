import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/core/services/connectivity_service.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import '../data/crop_repository.dart';
import 'crop_analysis_notifier.dart';
import 'crop_analysis_state.dart';

/// Provider for ConnectivityService
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Provider for S3 Dio instance (no auth headers for direct S3 uploads)
final s3DioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
});

/// Provider for CropRepository
/// 
/// Injects the authenticated Dio client and separate S3 Dio instance
final cropRepositoryProvider = Provider<CropRepository>((ref) {
  // Get the authenticated Dio instance from auth providers
  final dio = ref.watch(dioProvider);
  final s3Dio = ref.watch(s3DioProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  
  return CropRepository(
    dio: dio,
    s3Dio: s3Dio,
    connectivityService: connectivityService,
  );
});

/// Provider for CropAnalysisNotifier
/// 
/// Manages the state of crop analysis workflow
final cropAnalysisProvider = StateNotifierProvider<CropAnalysisNotifier, CropAnalysisState>((ref) {
  final repository = ref.watch(cropRepositoryProvider);
  
  return CropAnalysisNotifier(repository: repository);
});
