import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/application/crop_analysis_providers.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/application/crop_analysis_state.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/presentation/widgets/image_source_button.dart';

class CropUploadScreen extends ConsumerStatefulWidget {
  const CropUploadScreen({super.key});

  @override
  ConsumerState<CropUploadScreen> createState() => _CropUploadScreenState();
}

class _CropUploadScreenState extends ConsumerState<CropUploadScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final state = ref.watch(cropAnalysisProvider);

    // Listen for state changes to navigate to processing screen
    ref.listen<CropAnalysisState>(cropAnalysisProvider, (previous, next) {
      if (next.status == CropAnalysisStatus.pollingResult) {
        context.push('/crop-processing');
      }
    });

    // Listen for auth state changes to handle token expiration
    ref.listen<AuthState>(authProvider, (previous, next) {
      // If user is logged out (token expired), navigate to login
      if (next.status == AuthStatus.initial ||
          next.status == AuthStatus.error) {
        // Show message and redirect to login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Session expired. Please login again.',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          context.go('/phone-input');
        }
      }
    });

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkSurface,
        elevation: 0,
        title: Text(
          'Crop Analysis',
          style: GoogleFonts.poppins(
            color: onDarkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: onDarkTextColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Instructions
                      Text(
                        'Capture or upload a photo of your crop',
                        style: GoogleFonts.poppins(
                          color: onDarkTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Get instant disease diagnosis and treatment recommendations',
                        style: GoogleFonts.poppins(
                          color: mutedTextColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Image Preview
                      if (_selectedImage != null)
                        Container(
                          height: screenHeight * 0.35,
                          decoration: BoxDecoration(
                            color: darkCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryGreen.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      if (_selectedImage != null)
                        SizedBox(height: screenHeight * 0.03),

                      // Image Source Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ImageSourceButton(
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              onPressed: _handleCameraCapture,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: ImageSourceButton(
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              onPressed: _handleGallerySelection,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Error Message
                      if (state.status == CropAnalysisStatus.error &&
                          state.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.red.shade300,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (state.status == CropAnalysisStatus.error)
                        SizedBox(height: screenHeight * 0.02),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              _selectedImage != null &&
                                  !_isLoading(state.status)
                              ? _handleSubmit
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: primaryGreen.withValues(
                              alpha: 0.3,
                            ),
                            disabledForegroundColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                            elevation: 2,
                            shadowColor: primaryGreen.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading(state.status)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _getLoadingText(state.status),
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Analyze Crop',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Handle camera capture with permission request
  Future<void> _handleCameraCapture() async {
    // Request camera permission
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // Permission granted, open camera
      try {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _selectedImage = image;
          });
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar('Failed to capture image. Please try again.');
        }
      }
    } else if (status.isDenied) {
      // Permission denied, show explanation dialog
      if (mounted) {
        _showPermissionDeniedDialog(
          'Camera Permission Required',
          'Camera access is needed to capture photos of your crops for disease analysis. Please grant camera permission to continue.',
          Permission.camera,
        );
      }
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, direct to settings
      if (mounted) {
        _showPermissionDeniedDialog(
          'Camera Permission Required',
          'Camera permission has been permanently denied. Please enable it in your device settings to use this feature.',
          Permission.camera,
          openSettings: true,
        );
      }
    }
  }

  /// Handle gallery selection with permission request
  Future<void> _handleGallerySelection() async {
    // Request photo library permission
    final status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      // Permission granted or limited (iOS 14+), open gallery
      try {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _selectedImage = image;
          });
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar('Failed to select image. Please try again.');
        }
      }
    } else if (status.isDenied) {
      // Permission denied, show explanation dialog
      if (mounted) {
        _showPermissionDeniedDialog(
          'Photo Library Permission Required',
          'Photo library access is needed to select photos of your crops for disease analysis. Please grant photo library permission to continue.',
          Permission.photos,
        );
      }
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, direct to settings
      if (mounted) {
        _showPermissionDeniedDialog(
          'Photo Library Permission Required',
          'Photo library permission has been permanently denied. Please enable it in your device settings to use this feature.',
          Permission.photos,
          openSettings: true,
        );
      }
    }
  }

  /// Handle submit button press
  Future<void> _handleSubmit() async {
    if (_selectedImage != null) {
      await ref
          .read(cropAnalysisProvider.notifier)
          .startAnalysis(_selectedImage!);
    }
  }

  /// Check if the current state is a loading state
  bool _isLoading(CropAnalysisStatus status) {
    return status == CropAnalysisStatus.gettingUrl ||
        status == CropAnalysisStatus.uploadingToS3 ||
        status == CropAnalysisStatus.confirmingUpload;
  }

  /// Get loading text based on current status
  String _getLoadingText(CropAnalysisStatus status) {
    switch (status) {
      case CropAnalysisStatus.gettingUrl:
        return 'Preparing...';
      case CropAnalysisStatus.uploadingToS3:
        return 'Uploading...';
      case CropAnalysisStatus.confirmingUpload:
        return 'Processing...';
      default:
        return 'Loading...';
    }
  }

  /// Show permission denied dialog
  void _showPermissionDeniedDialog(
    String title,
    String message,
    Permission permission, {
    bool openSettings = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: onDarkTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: mutedTextColor, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: mutedTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (openSettings) {
                await openAppSettings();
              } else {
                await permission.request();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              openSettings ? 'Open Settings' : 'Grant Permission',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Error',
          style: GoogleFonts.poppins(
            color: onDarkTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: mutedTextColor, fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
