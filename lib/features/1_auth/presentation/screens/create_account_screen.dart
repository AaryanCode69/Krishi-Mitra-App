import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_text_form_field.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: scaffoldColor,
        title: CommonTextWidget(
          data: 'Create Account',
          textColor: Colors.white,
          fontSize: 20,
        ),
      ),
      backgroundColor: scaffoldColor,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.widthOf(context) * 0.9,
            child: Column(
              children: [
                CustomTextFormField(
                  textEditingController: nameController,
                  onChange: (value) {},
                  content: 'Full name',
                  hint: 'Enter your full name',
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  textEditingController: cityController,
                  onChange: (value) {},
                  content: 'City',
                  hint: 'Enter your city',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
