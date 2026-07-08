// lib/app/modules/auth/controllers/register_controller.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterDropdownItem {
  final String id;
  final String name;

  const RegisterDropdownItem({
    required this.id,
    required this.name,
  });
}

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final pharmacyNameController = TextEditingController();
  final pharmacyAddressController = TextEditingController();
  final referralCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  final selectedDistrict = Rxn<RegisterDropdownItem>();
  final selectedPoliceStation = Rxn<RegisterDropdownItem>();

  final nidOrLicenseFile = Rx<File?>(null);
  final nidOrLicenseFileName = ''.obs;
  final nidOrLicenseBase64 = ''.obs;

  final districts = <RegisterDropdownItem>[
    const RegisterDropdownItem(id: 'dhaka', name: 'Dhaka'),
    const RegisterDropdownItem(id: 'chattogram', name: 'Chattogram'),
    const RegisterDropdownItem(id: 'sylhet', name: 'Sylhet'),
    const RegisterDropdownItem(id: 'rajshahi', name: 'Rajshahi'),
    const RegisterDropdownItem(id: 'khulna', name: 'Khulna'),
    const RegisterDropdownItem(id: 'barishal', name: 'Barishal'),
    const RegisterDropdownItem(id: 'rangpur', name: 'Rangpur'),
    const RegisterDropdownItem(id: 'mymensingh', name: 'Mymensingh'),
  ].obs;

  final policeStations = <RegisterDropdownItem>[].obs;

  final Map<String, List<RegisterDropdownItem>> _policeStationsByDistrict = {
    'dhaka': [
      const RegisterDropdownItem(id: 'dhanmondi', name: 'Dhanmondi'),
      const RegisterDropdownItem(id: 'mohammadpur', name: 'Mohammadpur'),
      const RegisterDropdownItem(id: 'mirpur', name: 'Mirpur'),
      const RegisterDropdownItem(id: 'uttara', name: 'Uttara'),
      const RegisterDropdownItem(id: 'gulshan', name: 'Gulshan'),
    ],
    'chattogram': [
      const RegisterDropdownItem(id: 'kotwali', name: 'Kotwali'),
      const RegisterDropdownItem(id: 'panchlaish', name: 'Panchlaish'),
      const RegisterDropdownItem(id: 'double_mooring', name: 'Double Mooring'),
    ],
    'sylhet': [
      const RegisterDropdownItem(id: 'kotwali_sylhet', name: 'Kotwali'),
      const RegisterDropdownItem(id: 'south_surma', name: 'South Surma'),
    ],
    'rajshahi': [
      const RegisterDropdownItem(id: 'boalia', name: 'Boalia'),
      const RegisterDropdownItem(id: 'motihar', name: 'Motihar'),
    ],
    'khulna': [
      const RegisterDropdownItem(id: 'sonadanga', name: 'Sonadanga'),
      const RegisterDropdownItem(id: 'khalishpur', name: 'Khalishpur'),
    ],
    'barishal': [
      const RegisterDropdownItem(id: 'kotwali_barishal', name: 'Kotwali'),
      const RegisterDropdownItem(id: 'airport_barishal', name: 'Airport'),
    ],
    'rangpur': [
      const RegisterDropdownItem(id: 'rangpur_sadar', name: 'Rangpur Sadar'),
      const RegisterDropdownItem(id: 'kotwali_rangpur', name: 'Kotwali'),
    ],
    'mymensingh': [
      const RegisterDropdownItem(id: 'mymensingh_sadar', name: 'Mymensingh Sadar'),
      const RegisterDropdownItem(id: 'kotwali_mymensingh', name: 'Kotwali'),
    ],
  };

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    pharmacyNameController.dispose();
    pharmacyAddressController.dispose();
    referralCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void setDistrict(RegisterDropdownItem? item) {
    selectedDistrict.value = item;
    selectedPoliceStation.value = null;
    policeStations.clear();

    if (item == null) return;

    policeStations.assignAll(
      _policeStationsByDistrict[item.id] ?? <RegisterDropdownItem>[],
    );
  }

  void setPoliceStation(RegisterDropdownItem? item) {
    selectedPoliceStation.value = item;
  }

  Future<void> showUploadSourceSheet() async {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text('Take Photo'.tr),
                onTap: () {
                  Get.back();
                  pickNidOrLicense(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('Choose From Gallery'.tr),
                onTap: () {
                  Get.back();
                  pickNidOrLicense(ImageSource.gallery);
                },
              ),
              if (nidOrLicenseFile.value != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text('Remove File'.tr),
                  onTap: () {
                    Get.back();
                    clearNidOrLicense();
                  },
                ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> pickNidOrLicense(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: 1800,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final bytes = await file.readAsBytes();

      nidOrLicenseFile.value = file;
      nidOrLicenseFileName.value = picked.name;
      nidOrLicenseBase64.value = base64Encode(bytes);
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to pick image'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearNidOrLicense() {
    nidOrLicenseFile.value = null;
    nidOrLicenseFileName.value = '';
    nidOrLicenseBase64.value = '';
  }

  String? validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Name is required'.tr;
    if (text.length < 2) return 'Name is too short'.tr;
    return null;
  }

  String? validateMobile(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Mobile number is required'.tr;

    final cleaned = text.replaceAll(RegExp(r'[^0-9+]'), '');
    final bdPattern = RegExp(r'^(?:\+?88)?01[3-9]\d{8}$');

    if (!bdPattern.hasMatch(cleaned)) {
      return 'Enter a valid mobile number'.tr;
    }

    return null;
  }

  String? validatePharmacyName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Pharmacy name is required'.tr;
    if (text.length < 2) return 'Pharmacy name is too short'.tr;
    return null;
  }

  String? validateDistrict(RegisterDropdownItem? value) {
    if (value == null) return 'District is required'.tr;
    return null;
  }

  String? validatePoliceStation(RegisterDropdownItem? value) {
    if (value == null) return 'Police station is required'.tr;
    return null;
  }

  String? validateAddress(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Pharmacy address is required'.tr;
    if (text.length < 6) return 'Address is too short'.tr;
    return null;
  }

  String? validatePassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Password is required'.tr;
    if (text.length < 6) return 'Password must be at least 6 characters'.tr;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Confirm password is required'.tr;
    if (text != passwordController.text.trim()) {
      return 'Password and confirm password do not match'.tr;
    }
    return null;
  }

  bool _validateUpload() {
    if (nidOrLicenseFile.value != null && nidOrLicenseBase64.value.isNotEmpty) {
      return true;
    }

    Get.snackbar(
      'Required'.tr,
      'Please upload NID or license image'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  Map<String, dynamic> get registrationPayload {
    return {
      'name': nameController.text.trim(),
      'phone': mobileController.text.trim(),
      'pharmacy_name': pharmacyNameController.text.trim(),
      'state': selectedDistrict.value?.id,

      'city': selectedPoliceStation.value?.id,

      'address': pharmacyAddressController.text.trim(),
      'referral_code': referralCodeController.text.trim(),
      'password': passwordController.text.trim(),

      'image1': nidOrLicenseBase64.value,

    };
  }

  Future<void> signUp() async {
    Get.focusScope?.unfocus();

    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (!_validateUpload()) return;

    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final payload = registrationPayload;

      // TODO: Replace this method body with your real registration repository call.
      // Example:
      // final res = await AuthRepository().registerPharmacy(payload);
      // if (res['status'] == 'success') { ... }
      await Future.delayed(const Duration(milliseconds: 500));

      debugPrint('Registration payload: $payload');

      Get.snackbar(
        'Success'.tr,
        'Registration information is ready to submit'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
