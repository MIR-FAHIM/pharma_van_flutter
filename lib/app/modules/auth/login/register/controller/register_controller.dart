// lib/app/modules/auth/controllers/register_controller.dart

import 'dart:io';

import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/models/location/district_model.dart';
import 'package:ecom_user_flutter/app/models/location/division_model.dart';
import 'package:ecom_user_flutter/app/models/location/upazila_model.dart';
import 'package:ecom_user_flutter/app/repositories/auth_repositories.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  static const String _locationBearerToken =
      'EN1U4E6rdWlNd73ejFB1QROIGbviftipDzyex8NpW05VqLoq7k03HtDFslIoirLj';
  static const String _upazilaBearerToken =
      'oOLNpZVbEYJAuZMmh3QfarEusqhGje31kGGLCICsyBaQydWw1wQLZPqPnCtDSJvx';

  static const Map<String, String> _locationHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_locationBearerToken',
  };
  static const Map<String, String> _upazilaHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_upazilaBearerToken',
  };

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final pharmacyNameController = TextEditingController();
  final pharmacyAddressController = TextEditingController();
  final referralCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isDivisionLoading = false.obs;
  final isDistrictLoading = false.obs;
  final isPoliceStationLoading = false.obs;
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  final selectedDivision = Rxn<DivisionModel>();
  final selectedDistrict = Rxn<DistrictModel>();
  final selectedPoliceStation = Rxn<UpazilaModel>();

  final nidOrLicenseFile = Rx<File?>(null);
  final nidOrLicenseFileName = ''.obs;

  final divisions = <DivisionModel>[].obs;
  final districts = <DistrictModel>[].obs;
  final policeStations = <UpazilaModel>[].obs;
  int _districtRequestId = 0;
  int _policeStationRequestId = 0;

  @override
  void onInit() {
    super.onInit();
    fetchDivisions();
  }

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

  Future<void> fetchDivisions() async {
    if (isDivisionLoading.value) return;

    isDivisionLoading.value = true;

    try {
      final response = await APIManager().getWithHeader(
        ApiClient.locationDivisions,
        Map<String, String>.from(_locationHeaders),
      );
      final model = DivisionResponse.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      divisions.assignAll(model.data);
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to load divisions'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDivisionLoading.value = false;
    }
  }

  Future<void> fetchDistricts(int divisionId) async {
    final requestId = ++_districtRequestId;
    isDistrictLoading.value = true;

    try {
      final response = await APIManager().getWithHeader(
        ApiClient.locationDistricts(divisionId),
        Map<String, String>.from(_locationHeaders),
      );
      final model = DistrictResponse.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      if (requestId == _districtRequestId &&
          selectedDivision.value?.id == divisionId) {
        districts.assignAll(model.data);
      }
    } catch (e) {
      if (requestId == _districtRequestId) {
        Get.snackbar(
          'Error'.tr,
          'Failed to load districts'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (requestId == _districtRequestId) {
        isDistrictLoading.value = false;
      }
    }
  }

  void setDivision(DivisionModel? item) {
    selectedDivision.value = item;
    selectedDistrict.value = null;
    selectedPoliceStation.value = null;
    districts.clear();
    policeStations.clear();
    _policeStationRequestId++;
    isPoliceStationLoading.value = false;

    final divisionId = item?.id;
    if (divisionId == null) return;

    fetchDistricts(divisionId);
  }

  void setDistrict(DistrictModel? item) {
    selectedDistrict.value = item;
    selectedPoliceStation.value = null;
    policeStations.clear();

    if (item == null) return;

    final districtId = item.id;
    if (districtId == null) return;

    fetchPoliceStations(districtId);
  }

  Future<void> fetchPoliceStations(int districtId) async {
    final requestId = ++_policeStationRequestId;
    isPoliceStationLoading.value = true;

    try {
      final response = await APIManager().getWithHeader(
        ApiClient.locationUpazilas(districtId),
        Map<String, String>.from(_upazilaHeaders),
      );
      final model = UpazilaResponse.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      if (requestId == _policeStationRequestId &&
          selectedDistrict.value?.id == districtId) {
        policeStations.assignAll(model.data);
      }
    } catch (e) {
      if (requestId == _policeStationRequestId) {
        Get.snackbar(
          'Error'.tr,
          'Failed to load police stations'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (requestId == _policeStationRequestId) {
        isPoliceStationLoading.value = false;
      }
    }
  }

  void setPoliceStation(UpazilaModel? item) {
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

      nidOrLicenseFile.value = file;
      nidOrLicenseFileName.value = picked.name;
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

  String? validateDivision(DivisionModel? value) {
    if (value == null) return 'Division is required'.tr;
    return null;
  }

  String? validateDistrict(DistrictModel? value) {
    if (value == null) return 'District is required'.tr;
    return null;
  }

  String? validatePoliceStation(UpazilaModel? value) {
    if (isPoliceStationLoading.value) {
      return 'Please wait for police stations to load'.tr;
    }
    if (policeStations.isEmpty) return null;
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
    if (nidOrLicenseFile.value != null) {
      return true;
    }

    Get.snackbar(
      'Required'.tr,
      'Please upload NID or license image'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  Map<String, String> get registrationPayload {
    final payload = <String, String>{
      'name': nameController.text.trim(),
      'phone': mobileController.text.trim(),
      'pharmacy_name': pharmacyNameController.text.trim(),
      'state': selectedDivision.value?.id?.toString() ?? '',
      'city': selectedDistrict.value?.id?.toString() ?? '',
      'address': pharmacyAddressController.text.trim(),
      'referral_code': referralCodeController.text.trim(),
      'password': passwordController.text.trim(),
    };

    final policeStationId = selectedPoliceStation.value?.id;
    if (policeStationId != null) {
      payload['police_station'] = policeStationId.toString();
    }

    return payload;
  }

  Future<void> signUp() async {
    print("is called");
    Get.focusScope?.unfocus();
    print("is called1");
    final valid = formKey.currentState?.validate() ?? false;
    print("is called2");
    if (!valid) return;
    print("is called3");
    if (isPoliceStationLoading.value) {
      Get.snackbar(
        'Please wait'.tr,
        'Police stations are still loading'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_validateUpload()) return;

    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final payload = registrationPayload;
      final imageFile = nidOrLicenseFile.value;
      if (imageFile == null) return;

      final resp = await AuthRepository().signUpWithImage(payload, imageFile);

      debugPrint('Registration payload: $payload');

      if (resp is Map && resp['status'] == 'success') {
        Get.snackbar(
          'Success'.tr,
          resp['message']?.toString() ?? 'Registration completed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Error'.tr,
          resp is Map
              ? resp['message']?.toString() ?? 'Registration failed'.tr
              : 'Registration failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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
