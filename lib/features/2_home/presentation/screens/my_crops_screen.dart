import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/application/home_providers.dart';
import 'package:krishi_mitra/features/2_home/domain/crop_submission.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/my_crops_list_item.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class MyCropsScreen extends ConsumerWidget {
  const MyCropsScreen({super.key});

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropSubmissions = ref.watch(cropHistorySummaryProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        title: const CommonTextWidget(
          data: 'My Crops',
          textColor: onDarkTextColor,
          fontSize: 20,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemBuilder: (context, index) {
          final submission = cropSubmissions[index];
          return MyCropListItem(
            cropName: submission.cropName,
            status: submission.status == CropHealthStatus.healthy
                ? 'Healthy'
                : 'Needs Attention',
            statusColor: submission.status == CropHealthStatus.healthy
                ? primaryGreen
                : Colors.orange,
            timestamp: _formatTimestamp(submission.submittedAt),
            badgeText: submission.status == CropHealthStatus.healthy
                ? 'Good'
                : 'Alert',
            onTap: () {},
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: cropSubmissions.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.black),
        backgroundColor: primaryGreen,
        label: const Text(
          'Add Crop',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
              context.push('/market-prices');
              break;
            case 3:
              context.go('/crops');
              break;
            case 4:
              context.push('/history');
              break;
          }
        },
      ),
    );
  }
}
