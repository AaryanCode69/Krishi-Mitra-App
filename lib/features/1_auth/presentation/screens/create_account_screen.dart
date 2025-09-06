import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_drop_down_button.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/custom_text_form_field.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final String? selected = null;

  final List<String> items = [
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
    nameController.dispose();
    cityController.dispose();
    districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.widthOf(context);
    double height = MediaQuery.heightOf(context);
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
            width: width * 0.9,
            child: Column(
              children: [
                CustomTextFormField(
                  textEditingController: nameController,
                  onChange: (value) {},
                  content: 'Full name',
                  hint: 'Enter your full name',
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  textEditingController: cityController,
                  onChange: (value) {},
                  content: 'City',
                  hint: 'Enter your city',
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  textEditingController: districtController,
                  onChange: (value) {},
                  content: 'District',
                  hint: 'Enter your district',
                ),
                const SizedBox(height: 25),
                CustomDropDownButton(
                  items: items,
                  onChanged: (value) {},
                  value: selected,
                ),
                const SizedBox(height: 70),
                CommonElevatedButton(
                  onTouch: () {},
                  textWidget: CommonTextWidget(
                    data: 'Register',
                    textColor: cardColor,
                    fontSize: 20,
                  ),
                  color: cardTextColor,
                  height: height * 0.09,
                  width: width * 0.85,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
