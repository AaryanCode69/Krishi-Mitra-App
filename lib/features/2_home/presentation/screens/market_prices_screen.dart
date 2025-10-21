import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';

class MarketPricesScreen extends StatelessWidget {
  const MarketPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Market Prices',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Select State Dropdown
              _buildDropdown(
                context,
                label: 'Select State',
                onTap: () {
                  // TODO: Show state picker
                },
              ),
              
              SizedBox(height: screenWidth * 0.04),
              
              // Select District Dropdown
              _buildDropdown(
                context,
                label: 'Select District',
                onTap: () {
                  // TODO: Show district picker
                },
              ),
              
              SizedBox(height: screenWidth * 0.04),
              
              // Select Crop Dropdown
              _buildDropdown(
                context,
                label: 'Select Crop',
                onTap: () {
                  // TODO: Show crop picker
                },
              ),
              
              SizedBox(height: screenWidth * 0.08),
              
              // Current Prices Header
              Text(
                'Current Prices',
                style: GoogleFonts.poppins(
                  color: onDarkTextColor,
                  fontSize: (screenWidth * 0.045).clamp(16.0, 18.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: screenWidth * 0.04),
              
              // Price Table Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: darkCard,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Commodity',
                        style: GoogleFonts.poppins(
                          color: mutedTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Min Price',
                        style: GoogleFonts.poppins(
                          color: mutedTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Max Price',
                        style: GoogleFonts.poppins(
                          color: mutedTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Price Rows
              _buildPriceRow('Rice', '₹1,800', '₹2,500', isFirst: true),
              _buildPriceRow('Wheat', '₹2,200', '₹2,800'),
              _buildPriceRow('Cotton', '₹6,500', '₹7,500'),
              _buildPriceRow('Sugarcane', '₹350', '₹450', isLast: true),
              
              SizedBox(height: screenWidth * 0.06),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.push('/scan');
              break;
            case 2:
              context.go('/market-prices');
              break;
            case 3:
              context.push('/crops');
              break;
          }
        },
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.045,
        ),
        decoration: BoxDecoration(
          color: darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryGreen.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: mutedTextColor,
                  fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: mutedTextColor,
              size: (screenWidth * 0.06).clamp(20.0, 24.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String commodity,
    String minPrice,
    String maxPrice, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: darkCard,
        border: Border(
          top: isFirst
              ? BorderSide.none
              : BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
        ),
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              commodity,
              style: GoogleFonts.poppins(
                color: onDarkTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              minPrice,
              style: GoogleFonts.poppins(
                color: onDarkTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              maxPrice,
              style: GoogleFonts.poppins(
                color: onDarkTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
