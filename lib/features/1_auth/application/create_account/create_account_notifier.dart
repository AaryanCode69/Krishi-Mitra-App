import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_mitra/features/2_home/application/home_providers.dart';

import 'create_account_state.dart';

class CreateAccountNotifier extends StateNotifier<CreateAccountState> {
  CreateAccountNotifier(this._ref)
      : _nameController = TextEditingController(),
        _cityController = TextEditingController(),
        _districtController = TextEditingController(),
        _formKey = GlobalKey<FormState>(),
        super(const CreateAccountState());

  final Ref _ref;
  final TextEditingController _nameController;
  final TextEditingController _cityController;
  final TextEditingController _districtController;
  final GlobalKey<FormState> _formKey;

  final List<String> _states = const [
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

  TextEditingController get nameController => _nameController;
  TextEditingController get cityController => _cityController;
  TextEditingController get districtController => _districtController;
  GlobalKey<FormState> get formKey => _formKey;
  List<String> get states => _states;

  void _clearInlineError() {
    if (state.formError != null) {
      state = state.copyWith(resetError: true);
    }
  }

  void onFieldChanged(String value) => _clearInlineError();

  void onStateChanged(String? value) {
    _clearInlineError();
    state = state.copyWith(selectedState: value);
  }

  String? validateName(String? value) => null;
  String? validateCity(String? value) => null;
  String? validateDistrict(String? value) => null;

  String? validateState(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Please select your state';
    }
    return null;
  }

  Future<void> register(BuildContext context) async {
    if (!context.mounted) return;
    _ref.read(homeNavIndexProvider.notifier).state = 0;
    GoRouter.of(context).go('/home');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }
}
