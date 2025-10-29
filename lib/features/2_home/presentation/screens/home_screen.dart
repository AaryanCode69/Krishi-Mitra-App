import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/scan_crop_card.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/weather_card.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/mandi_summary_card.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/my_crops_list_item.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: homeBackground,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scan Crop Card
              ScanCropCard(
                onTap: () {
                  context.push('/crop-upload');
                },
              ),
              const SizedBox(height: 16),
              
              // Weather and Mandi Cards Row
              Row(
                children: [
                  Expanded(
                    child: WeatherCard(
                      temperature: dummyWeather['temperature']!,
                      location: dummyWeather['location']!,
                      onForecastTap: () {
                        context.push('/weather');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MandiSummaryCard(
                      primaryCrop: dummyMandiPrices['primaryCrop']!,
                      primaryPrice: dummyMandiPrices['primaryPrice']!,
                      secondaryCrop: dummyMandiPrices['secondaryCrop']!,
                      secondaryPrice: dummyMandiPrices['secondaryPrice']!,
                      onViewAllTap: () {
                        context.push('/market-prices');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // My Crops Section
              Text(
                'My Crops',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              
              // Crop List Items
              MyCropListItem(
                cropName: dummyCrops[0]['name'] as String,
                status: dummyCrops[0]['status'] as String,
                statusColor: dummyCrops[0]['statusColor'] as Color,
                timestamp: dummyCrops[0]['timestamp'] as String,
                badgeText: dummyCrops[0]['badgeText'] as String,
                onTap: () {
                  // Placeholder callback
                },
              ),
              const SizedBox(height: 12),
              MyCropListItem(
                cropName: dummyCrops[1]['name'] as String,
                status: dummyCrops[1]['status'] as String,
                statusColor: dummyCrops[1]['statusColor'] as Color,
                timestamp: dummyCrops[1]['timestamp'] as String,
                badgeText: dummyCrops[1]['badgeText'] as String,
                onTap: () {
                  // Placeholder callback
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 0,
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
              context.push('/crops');
              break;
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: homeBackground,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.grass,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      title: Text(
        'AgriAssist',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: darkCard,
            radius: 20,
            child: Icon(
              Icons.person_outline,
              color: primaryGreen,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

// Dummy data constants for weather, mandi prices, and crops
const dummyWeather = {
  'temperature': '28°C',
  'location': 'Vellore, TN',
};

const dummyMandiPrices = {
  'primaryCrop': 'Groundnut',
  'primaryPrice': '₹5,500',
  'secondaryCrop': 'Rice',
  'secondaryPrice': '₹2,200',
};

const dummyCrops = [
  {
    'name': 'Groundnut',
    'status': 'Healthy',
    'statusColor': Color(0xFF2ECC71),
    'timestamp': '2 days ago',
    'badgeText': 'View Details',
  },
  {
    'name': 'Tomato',
    'status': 'Early Blight',
    'statusColor': Color(0xFFF6C945),
    'timestamp': '5 days ago',
    'badgeText': 'Needs Attention',
  },
];
