import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/4_crop_history/application/crop_history_providers.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';

class CropHistoryScreen extends ConsumerWidget {
  const CropHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(cropHistoryListProvider);

    return Scaffold(
      backgroundColor: homeBackground,
      appBar: AppBar(
        backgroundColor: homeBackground,
        elevation: 0,
        title: Text(
          'My Crops',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cropHistoryListProvider);
        },
        color: primaryGreen,
        backgroundColor: darkCard,
        child: historyState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: primaryGreen,
            ),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (submissions) {
            if (submissions.isEmpty) {
              return _buildEmptyState();
            }
            return _buildHistoryList(submissions);
          },
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.push('/scan');
              break;
            case 2:
              context.push('/prices');
              break;
            case 3:
              // Already on history screen
              break;
          }
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load history',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: mutedTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(cropHistoryListProvider);
              },
              icon: const Icon(Icons.refresh),
              label: Text(
                'Retry',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: mutedTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No Crop History',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your crop submissions will appear here',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: mutedTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List submissions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: submissions.length,
      itemBuilder: (context, index) {
        final submission = submissions[index];
        // Placeholder for HistoryItemCard widget (Task 5)
        return _buildHistoryItemPlaceholder(submission);
      },
    );
  }

  // Temporary placeholder until HistoryItemCard is implemented in Task 5
  Widget _buildHistoryItemPlaceholder(dynamic submission) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: homeCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: darkCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image,
                color: mutedTextColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    submission.diseaseName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(submission.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      submission.status,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return primaryGreen;
      case 'PROCESSING':
        return warningAmber;
      case 'FAILED':
        return Colors.red;
      default:
        return mutedTextColor;
    }
  }
}
