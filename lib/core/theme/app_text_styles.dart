import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One font, Poppins, on a standard mobile type scale:
/// display 26 · heading 22 / 19 / 17 · title 15 / 14 · body 14 · caption 12 · label 11.
/// Colors are left empty so the text picks up the theme color,
/// use `.copyWith(color: ...)` when a different color is needed.
class AppTextStyles {
  /// Onboarding and paywall headlines.
  static TextStyle get display => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.2,
      );

  /// Page titles.
  static TextStyle get heading1 => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get heading2 => GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// Section titles, e.g. "Live offers".
  static TextStyle get heading3 => GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Card titles.
  static TextStyle get title => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.35,
      );

  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.35,
      );

  static TextStyle get priceHuge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle get priceLarge => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.1,
      );

  static TextStyle get price => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get priceSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get bodySemiBold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  static TextStyle get captionMedium => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// Small capitals, e.g. "TRENDING NOW".
  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      );

  /// Badges such as "52% OFF" and "PRO".
  static TextStyle get tag => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );
}
