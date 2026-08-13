// lib/app/modules/auth/views/register_view.dart
import 'dart:io';
import 'dart:ui';
import 'package:ecom_user_flutter/app/models/location/district_model.dart';
import 'package:ecom_user_flutter/app/models/location/division_model.dart';
import 'package:ecom_user_flutter/app/models/location/upazila_model.dart';
import 'package:ecom_user_flutter/app/modules/auth/login/register/controller/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  static const Color _navy = Color(0xFF1F214C);
  static const Color _accent = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const _Background(),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
                child: Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(
                        title: 'Create Pharmacy Account'.tr,
                        subtitle: 'Fill the pharmacy details to register.'.tr,
                        onBack: () => Get.back(),
                      ),
                      const SizedBox(height: 16),
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _SectionTitle(title: 'Owner Information'.tr),
                            const SizedBox(height: 12),
                            _Input(
                              controller: controller.nameController,
                              label: 'Name'.tr,
                              hint: 'Your full name'.tr,
                              icon: CupertinoIcons.person,
                              keyboardType: TextInputType.name,
                              validator: controller.validateName,
                            ),
                            const SizedBox(height: 12),
                            _Input(
                              controller: controller.mobileController,
                              label: 'Mobile Number'.tr,
                              hint: '01XXXXXXXXX'.tr,
                              icon: CupertinoIcons.device_phone_portrait,
                              keyboardType: TextInputType.phone,
                              validator: controller.validateMobile,
                            ),
                            const SizedBox(height: 16),
                            _SectionTitle(title: 'Pharmacy Information'.tr),
                            const SizedBox(height: 12),
                            _Input(
                              controller: controller.pharmacyNameController,
                              label: 'Pharmacy Name'.tr,
                              hint: 'Your pharmacy name'.tr,
                              icon: Icons.local_pharmacy_outlined,
                              keyboardType: TextInputType.text,
                              validator: controller.validatePharmacyName,
                            ),
                            const SizedBox(height: 12),
                            Obx(() {
                              final isLoading =
                                  controller.isDivisionLoading.value;
                              final enabled = !isLoading &&
                                  controller.divisions.isNotEmpty;

                              return _DropdownInput<DivisionModel>(
                                label: 'Division'.tr,
                                hint: isLoading
                                    ? 'Loading divisions...'.tr
                                    : 'Select division'.tr,
                                icon: Icons.map_outlined,
                                value: controller.selectedDivision.value,
                                items: controller.divisions,
                                labelOf: (item) => item.name ?? '',
                                onChanged:
                                    enabled ? controller.setDivision : null,
                                validator: controller.validateDivision,
                              );
                            }),
                            const SizedBox(height: 12),
                            Obx(() {
                              final selectedDivision =
                                  controller.selectedDivision.value;
                              final isLoading =
                                  controller.isDistrictLoading.value;
                              final enabled = selectedDivision != null &&
                                  !isLoading &&
                                  controller.districts.isNotEmpty;

                              return _DropdownInput<DistrictModel>(
                                label: 'District'.tr,
                                hint: selectedDivision == null
                                    ? 'Select division first'.tr
                                    : isLoading
                                        ? 'Loading districts...'.tr
                                        : controller.districts.isEmpty
                                            ? 'No district available'.tr
                                            : 'Select district'.tr,
                                icon: Icons.location_city_outlined,
                                value: controller.selectedDistrict.value,
                                items: controller.districts,
                                labelOf: (item) => item.name ?? '',
                                onChanged:
                                    enabled ? controller.setDistrict : null,
                                validator: controller.validateDistrict,
                              );
                            }),
                            const SizedBox(height: 12),
                            Obx(() {
                              final selectedDistrict =
                                  controller.selectedDistrict.value;
                              final isLoading =
                                  controller.isPoliceStationLoading.value;
                              final hasPoliceStations =
                                  controller.policeStations.isNotEmpty;

                              return _DropdownInput<UpazilaModel>(
                                label: 'Police Station'.tr,
                                hint: selectedDistrict == null
                                    ? 'Select district first'.tr
                                    : isLoading
                                        ? 'Loading police stations...'.tr
                                        : hasPoliceStations
                                            ? 'Select police station'.tr
                                            : 'No police station available'.tr,
                                icon: Icons.account_balance_outlined,
                                value: controller.selectedPoliceStation.value,
                                items: controller.policeStations,
                                labelOf: (item) => item.name ?? '',
                                onChanged: selectedDistrict == null ||
                                        isLoading ||
                                        !hasPoliceStations
                                    ? null
                                    : controller.setPoliceStation,
                                validator: controller.validatePoliceStation,
                              );
                            }),
                            const SizedBox(height: 12),
                            _Input(
                              controller: controller.pharmacyAddressController,
                              label: 'Pharmacy Address'.tr,
                              hint: 'Road, area, police station, district'.tr,
                              icon: CupertinoIcons.location_solid,
                              keyboardType: TextInputType.streetAddress,
                              maxLines: 3,
                              validator: controller.validateAddress,
                            ),
                            const SizedBox(height: 12),
                            _Input(
                              controller: controller.referralCodeController,
                              label: 'Referral Code'.tr,
                              hint: 'Optional'.tr,
                              icon: Icons.card_giftcard_outlined,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 16),
                            _SectionTitle(title: 'Verification'.tr),
                            const SizedBox(height: 12),
                            Obx(() {
                              return _UploadBox(
                                file: controller.nidOrLicenseFile.value,
                                fileName: controller.nidOrLicenseFileName.value,
                                onTap: controller.showUploadSourceSheet,
                                onClear: controller.clearNidOrLicense,
                              );
                            }),
                            const SizedBox(height: 16),
                            _SectionTitle(title: 'Security'.tr),
                            const SizedBox(height: 12),
                            Obx(() {
                              return _Input(
                                controller: controller.passwordController,
                                label: 'Password'.tr,
                                hint: '••••••'.tr,
                                icon: CupertinoIcons.lock,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: controller.hidePassword.value,
                                validator: controller.validatePassword,
                                suffix: IconButton(
                                  onPressed: () {
                                    controller.hidePassword.value =
                                    !controller.hidePassword.value;
                                  },
                                  icon: Icon(
                                    controller.hidePassword.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: controller.hidePassword.value
                                        ? Colors.grey
                                        : _navy,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            Obx(() {
                              return _Input(
                                controller: controller.confirmPasswordController,
                                label: 'Confirm Password'.tr,
                                hint: '••••••'.tr,
                                icon: CupertinoIcons.lock_shield,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: controller.hideConfirmPassword.value,
                                validator: controller.validateConfirmPassword,
                                suffix: IconButton(
                                  onPressed: () {
                                    controller.hideConfirmPassword.value =
                                    !controller.hideConfirmPassword.value;
                                  },
                                  icon: Icon(
                                    controller.hideConfirmPassword.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: controller.hideConfirmPassword.value
                                        ? Colors.grey
                                        : _navy,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 18),
                            Obx(() {
                              return SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _accent,
                                    disabledBackgroundColor:
                                    _accent.withOpacity(0.55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.signUp,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.isLoading.value) ...[
                                        const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                      Text(
                                        controller.isLoading.value
                                            ? 'Please wait...'.tr
                                            : 'Create Account'.tr,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            Text(
                              'By continuing, you agree to our Terms & Privacy Policy.'.tr,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?'.tr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Login'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.file,
    required this.fileName,
    required this.onTap,
    required this.onClear,
  });

  final File? file;
  final String fileName;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasFile ? RegisterView._accent : Colors.black12,
            width: hasFile ? 1.2 : 0.9,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasFile
                  ? Image.file(file!, fit: BoxFit.cover)
                  : const Icon(
                Icons.badge_outlined,
                color: RegisterView._navy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NID or License Upload'.tr,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasFile
                        ? fileName
                        : 'Upload NID, drug license, or pharmacy license'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasFile ? RegisterView._accent : Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (hasFile)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, color: Colors.red),
              )
            else
              const Icon(Icons.upload_file_rounded, color: RegisterView._navy),
          ],
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1F214C),
                  Color(0xFF0B1220),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -60,
            child: _Blob(
              color: const Color(0xFF16A34A).withOpacity(0.25),
              size: 220,
            ),
          ),
          Positioned(
            bottom: 70,
            right: -70,
            child: _Blob(
              color: const Color(0xFFF4B73E).withOpacity(0.20),
              size: 240,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.18)),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.82),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.65)),
            boxShadow: [
              BoxShadow(
                blurRadius: 26,
                offset: const Offset(0, 16),
                color: Colors.black.withOpacity(0.22),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: RegisterView._accent,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffix,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.35),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: RegisterView._navy),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorMaxLines: 2,
      ),
    );
  }
}

class _DropdownInput<T> extends StatelessWidget {
  const _DropdownInput({
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.validator,
  });

  final String label;
  final String hint;
  final IconData icon;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            labelOf(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.35),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: enabled ? RegisterView._navy : Colors.grey,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorMaxLines: 2,
      ),
    );
  }
}
