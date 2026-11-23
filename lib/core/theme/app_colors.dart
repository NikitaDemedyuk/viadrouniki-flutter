import 'package:flutter/material.dart';

abstract final class AppColors {
  /// The web app's accent. White text on it is 2.3:1, so it is kept for map
  /// pins and indicators, and the light theme's [primaryLight] is a darker
  /// green from the same scale.
  static const brand = Color(0xFF52C41A);

  static const primaryLight = Color(0xFF237804);
  static const onPrimaryLight = Color(0xFFFFFFFF);
  static const primaryContainerLight = Color(0xFFD9F7BE);
  static const onPrimaryContainerLight = Color(0xFF135200);
  static const surfaceLight = Color(0xFFF8FAF2);
  static const surfaceContainerLowLight = Color(0xFFF2F5EC);
  static const surfaceContainerLight = Color(0xFFECEFE5);
  static const surfaceContainerHighLight = Color(0xFFE6E9E0);
  static const onSurfaceLight = Color(0xFF191D16);
  static const onSurfaceVariantLight = Color(0xFF43483F);
  static const outlineLight = Color(0xFF73796E);
  static const outlineVariantLight = Color(0xFFC3C8BB);
  static const errorLight = Color(0xFFBA1A1A);
  static const onErrorLight = Color(0xFFFFFFFF);
  static const errorContainerLight = Color(0xFFFFDAD6);
  static const onErrorContainerLight = Color(0xFF410002);
  static const seasonSummerLight = Color(0xFFC93400);
  static const seasonWinterLight = Color(0xFF0040DD);

  static const Color primaryDark = brand;
  static const onPrimaryDark = Color(0xFF092B00);
  static const primaryContainerDark = Color(0xFF1D3712);
  static const onPrimaryContainerDark = Color(0xFF95DE64);
  static const surfaceDark = Color(0xFF11140F);
  static const surfaceContainerLowDark = Color(0xFF1C2018);
  static const surfaceContainerDark = Color(0xFF1F231C);
  static const surfaceContainerHighDark = Color(0xFF2A2E26);
  static const onSurfaceDark = Color(0xFFE1E4D9);
  static const onSurfaceVariantDark = Color(0xFFC3C8BB);
  static const outlineDark = Color(0xFF8D9387);
  static const outlineVariantDark = Color(0xFF43483F);
  static const errorDark = Color(0xFFFFB4AB);
  static const onErrorDark = Color(0xFF690005);
  static const errorContainerDark = Color(0xFF93000A);
  static const onErrorContainerDark = Color(0xFFFFDAD6);
  static const seasonSummerDark = Color(0xFFFFB340);
  static const seasonWinterDark = Color(0xFF409CFF);
}
