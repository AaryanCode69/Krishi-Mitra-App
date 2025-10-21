import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_drop_down_button.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_text_form_field.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createAccountProvider);
    final notifier = ref.read(createAccountProvider.notifier);

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
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
            key: notifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  textEditingController: notifier.nameController,
                  onChange: notifier.onFieldChanged,
                  content: 'Full Name',
                  hint: 'Enter your full name',
                  labelColor: onDarkTextColor,
                  validator: notifier.validateName,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textEditingController: notifier.cityController,
                  onChange: notifier.onFieldChanged,
                  content: 'City',
                  hint: 'Enter your city',
                  labelColor: onDarkTextColor,
                  validator: notifier.validateCity,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textEditingController: notifier.districtController,
                  onChange: notifier.onFieldChanged,
                  content: 'District',
                  hint: 'Enter your district',
                  labelColor: onDarkTextColor,
                  validator: notifier.validateDistrict,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomDropDownButton(
                  items: notifier.states,
                  onChanged: notifier.onStateChanged,
                  value: state.selectedState,
                  validator: notifier.validateState,
                  label: 'State',
                  labelColor: onDarkTextColor,
                ),
                if (state.formError != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    state.formError!,
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                CommonElevatedButton(
                  onTouch: () => notifier.register(context),
                  color: primaryGreen,
                  height: height * 0.085,
                  width: width * 0.85,
                  isLoading: state.status.isLoading,
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
