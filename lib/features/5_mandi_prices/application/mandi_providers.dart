import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/application/crop_analysis_providers.dart';
import '../data/mandi_repository.dart';
import 'mandi_notifier.dart';
import 'mandi_state.dart';

/// Provider for MandiRepository
/// 
/// Injects the authenticated Dio client and ConnectivityService
final mandiRepositoryProvider = Provider<MandiRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  
  return MandiRepository(
    dio: dio,
    connectivityService: connectivityService,
  );
});

/// Provider for MandiNotifier
/// 
/// Manages the state of mandi prices feature
final mandiProvider = StateNotifierProvider<MandiNotifier, MandiState>((ref) {
  final repository = ref.watch(mandiRepositoryProvider);
  
  return MandiNotifier(repository: repository);
});
