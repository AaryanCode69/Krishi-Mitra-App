import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/core/services/connectivity_service.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/4_crop_history/data/crop_history_repository.dart';
import 'package:krishi_mitra/features/4_crop_history/domain/crop_submission_summary.dart';
import 'package:krishi_mitra/features/4_crop_history/domain/crop_submission_detail.dart';

/// Provider for ConnectivityService
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Provider for CropHistoryRepository
/// Depends on dioProvider (with JWT interceptor) and connectivityServiceProvider
final cropHistoryRepositoryProvider = Provider<CropHistoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return CropHistoryRepository(
    dio: dio,
    connectivityService: connectivityService,
  );
});

/// FutureProvider for fetching the list of crop submissions
/// Automatically caches results and provides loading/error/data states
final cropHistoryListProvider =
    FutureProvider<List<CropSubmissionSummary>>((ref) async {
  final repository = ref.watch(cropHistoryRepositoryProvider);
  return repository.fetchHistoryList();
});

/// FutureProvider.family for fetching detailed information for a specific submission
/// Accepts submissionId as parameter and provides loading/error/data states
final cropHistoryDetailProvider =
    FutureProvider.family<CropSubmissionDetail, String>(
  (ref, submissionId) async {
    final repository = ref.watch(cropHistoryRepositoryProvider);
    return repository.fetchHistoryDetail(submissionId);
  },
);
