import 'package:flutter/material.dart';

class AppColors {
  // ---------------------------------------------------------------------------
  // PharmaVan Brand Core Colors
  // ---------------------------------------------------------------------------

  static const Color primaryColor = Color(0xFF2F8F2F);       // PharmaVan green
  static const Color primaryGreen = Color(0xFF2F8F2F);
  static const Color primaryDarkGreen = Color(0xFF1F6F2A);
  static const Color primaryLightGreen = Color(0xFFEAF7EC);

  static const Color secondaryColor = Color(0xFF002143);     // Deep navy
  static const Color primaryNavyColor = Color(0xFF002143);
  static const Color navyDark = Color(0xFF00172F);
  static const Color navySoft = Color(0xFFE8F1FA);

  static const Color accentBlue = Color(0xFF1F75B8);
  static const Color accentLightBlue = Color(0xFFE8F5FF);

  // ---------------------------------------------------------------------------
  // Background Colors
  // ---------------------------------------------------------------------------

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF6F8FA);
  static const Color secondBackgroundColor = Color(0xFFF1F5F4);
  static const Color thirdBackgroundColor = Color(0xFFEAF7EC);

  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color softCardBackground = Color(0xFFF8FAFC);
  static const Color searchFieldBackground = Color(0xFFF4F7F8);
  static const Color bottomNavBackground = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Text Colors
  // ---------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF101820);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF8A949E);
  static const Color textLight = Color(0xFFB8C0C8);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);

  // Existing compatibility names
  static const Color homeTextColor1 = Color(0xFF101820);
  static const Color homeTextColor2 = Color(0xFF4B5563);
  static const Color homeTextColor3 = Color(0xFF8A949E);
  static const Color textColorBlack = Color(0xFF000000);
  static const Color textAlt = Color(0xFF6B7280);

  // ---------------------------------------------------------------------------
  // Status Colors
  // ---------------------------------------------------------------------------

  static const Color successColor = Color(0xFF2F8F2F);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFE53935);
  static const Color infoColor = Color(0xFF1F75B8);

  static const Color greenTextColor = Color(0xFF2F8F2F);
  static const Color redTextColor = Color(0xFFE53935);

  // ---------------------------------------------------------------------------
  // Button Colors
  // ---------------------------------------------------------------------------

  static const Color buttonPrimary = Color(0xFF2F8F2F);
  static const Color buttonPrimaryDark = Color(0xFF1F6F2A);
  static const Color buttonSecondary = Color(0xFF002143);
  static const Color buttonDisabled = Color(0xFFD1D5DB);

  // ---------------------------------------------------------------------------
  // Icon Colors
  // ---------------------------------------------------------------------------

  static const Color iconPrimary = Color(0xFF2F8F2F);
  static const Color iconNavy = Color(0xFF002143);
  static const Color iconMuted = Color(0xFF8A949E);
  static const Color iconWhite = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Borders and Dividers
  // ---------------------------------------------------------------------------

  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color focusedBorderColor = Color(0xFF2F8F2F);
  static const Color tableRowColor = Color(0xFFF8FAFC);

  // ---------------------------------------------------------------------------
  // Category Colors
  // ---------------------------------------------------------------------------

  static const Color medicineColor = Color(0xFF2F8F2F);
  static const Color otcProductColor = Color(0xFFA5D63B);
  static const Color personalCareColor = Color(0xFF1F75B8);
  static const Color babyCareColor = Color(0xFF78C7E8);
  static const Color healthDeviceColor = Color(0xFF002143);
  static const Color prescriptionColor = Color(0xFF37A447);
  static const Color firstAidColor = Color(0xFFE53935);

  // ---------------------------------------------------------------------------
  // Offer, Highlight and Badge Colors
  // ---------------------------------------------------------------------------

  static const Color offerGreen = Color(0xFFEAF7EC);
  static const Color offerBlue = Color(0xFFE8F5FF);
  static const Color offerYellow = Color(0xFFFFF7D6);
  static const Color golden = Color(0xFFFFC107);
  static const Color discountColor = Color(0xFF2F8F2F);
  static const Color redColor = Color(0xFFE53935);

  // ---------------------------------------------------------------------------
  // Soft Backgrounds
  // ---------------------------------------------------------------------------

  static Color primaryGreenSoft = const Color(0xFF2F8F2F).withOpacity(0.10);
  static Color navySoftBg = const Color(0xFF002143).withOpacity(0.08);
  static Color blueSoftBg = const Color(0xFF1F75B8).withOpacity(0.10);
  static Color warningSoftBg = const Color(0xFFF59E0B).withOpacity(0.12);
  static Color errorSoftBg = const Color(0xFFE53935).withOpacity(0.10);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  static const Color gradientOne = Color(0xFF002143);
  static const Color gradientTwo = Color(0xFF2F8F2F);
  static const Color gradientThree = Color(0xFF1F75B8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2F8F2F),
      Color(0xFF1F6F2A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navyGradient = LinearGradient(
    colors: [
      Color(0xFF002143),
      Color(0xFF00172F),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ---------------------------------------------------------------------------
  // Old Variable Compatibility
  // Keep these so old pages do not break
  // ---------------------------------------------------------------------------

  static const Color themeAppColor = Color(0xFF2F8F2F);
  static const Color primaryDarkColor = Color(0xFF002143);
  static const Color primaryLightColor = Color(0xFFEAF7EC);

  static const Color featuredProductBg = Color(0xFFEAF7EC);
  static const Color allProductBg = Color(0xFFF1F5F4);

  static const Color homeCardBg = Color(0xFFFFFFFF);
  static const Color SectionCardBg = Color(0xFFF8FAFC);
  static const Color SectionHighLightCardBg = Color(0xFFEAF7EC);

  static const Color primarydeepLightColor = Color(0xFFEAF7EC);

  static const Color softPink = Color(0xFFFDECEC);
  static const Color softBrwn = Color(0xFF6B4F3A);

  static final todayDealColor = HexColor("#DF7529");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}