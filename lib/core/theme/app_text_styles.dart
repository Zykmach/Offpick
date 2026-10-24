import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Outfit is used for titles and prices, Inter for everything else.
/// Colors are left empty so the text picks up the theme color,
/// use `.copyWith(color: ...)` when a different color is needed.
class AppTextStyles {
  static TextStyle get display => GoogleFonts.outfit(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
      );

  static TextStyle get heading1 => GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.15,
      );

  static TextStyle get heading2 => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      );

  static TextStyle get heading3 => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  static TextStyle get title => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get titleSmall => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get priceHuge => GoogleFonts.outfit(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1,
      );

  static TextStyle get priceLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        height: 1,
      );

  static TextStyle get price => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  static TextStyle get priceSmall => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodySemiBold => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.35,
      );

  static TextStyle get captionMedium => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      );

  static TextStyle get tag => GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}
