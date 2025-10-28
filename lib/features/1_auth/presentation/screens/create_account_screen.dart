import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_drop_down_button.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_text_form_field.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedState;

  // List of Indian states
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your city';
    }
    return null;
  }

  String? _validateDistrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your district';
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your state';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    // Clear any previous errors
    ref.read(authProvider.notifier).clearProfileUpdateError();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get form values
    final fullName = _nameController.text.trim();
    final city = _cityController.text.trim();
    final district = _districtController.text.trim();
    final state = _selectedState!;

    try {
      // Call complete profile
      final success = await ref.read(authProvider.notifier).completeUserProfile(
            fullName: fullName,
            city: city,
            state: state,
            district: district,
          );

      if (!mounted) return;

      print('Profile update success: $success'); // Debug log

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile created successfully!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to home on success
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go('/home');
        }
      }
      // Error will be shown via state watching
    } catch (e) {
      print('Error in _handleRegister: $e'); // Debug log
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred: ${e.toString()}',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isLoading = authState.isUpdatingProfile;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkBackground,
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  textEditingController: _nameController,
                  onChange: (value) {
                    // Clear error when user types
                    if (authState.profileUpdateError != null) {
                      ref.read(authProvider.notifier).clearProfileUpdateError();
                    }
                  },
                  content: 'Full Name',
                  hint: 'Enter your full name',
                  labelColor: onDarkTextColor,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textEditingController: _cityController,
                  onChange: (value) {
                    if (authState.profileUpdateError != null) {
                      ref.read(authProvider.notifier).clearProfileUpdateError();
                    }
                  },
                  content: 'City',
                  hint: 'Enter your city',
                  labelColor: onDarkTextColor,
                  validator: _validateCity,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textEditingController: _districtController,
                  onChange: (value) {
                    if (authState.profileUpdateError != null) {
                      ref.read(authProvider.notifier).clearProfileUpdateError();
                    }
                  },
                  content: 'District',
                  hint: 'Enter your district',
                  labelColor: onDarkTextColor,
                  validator: _validateDistrict,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomDropDownButton(
                  items: _states,
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                    });
                    if (authState.profileUpdateError != null) {
                      ref.read(authProvider.notifier).clearProfileUpdateError();
                    }
                  },
                  value: _selectedState,
                  validator: _validateState,
                  label: 'State',
                  labelColor: onDarkTextColor,
                ),
                if (authState.profileUpdateError != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.profileUpdateError!,
                            style: GoogleFonts.poppins(
                              color: Colors.red.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                CommonElevatedButton(
                  onTouch: isLoading ? () {} : _handleRegister,
                  color: primaryGreen,
                  height: height * 0.085,
                  width: width * 0.85,
                  isLoading: isLoading,
                  child: Text(
                    'Register',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
