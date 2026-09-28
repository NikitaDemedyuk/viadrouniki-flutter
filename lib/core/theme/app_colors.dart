import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF52C41A);
  static const gold = Color(0xFFFAAD14);
  static const info = Color(0xFF1677FF);
  static const error = Color(0xFFFF4D4F);

  /// The web app puts white text on [primary], [gold], [info] and [error],
  /// which fails WCAG AA contrast on every one (as low as 1.9:1 on gold).
  static const onAccent = Color(0xFF0A0A0A);

  static const backgroundLight = Color(0xFFF5F5F5);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const fillLight = Color(0xFFF0F0F0);

  static const backgroundDark = Color(0xFF0A0A0A);
  static const surfaceDark = Color(0xFF141414);
  static const surfaceElevatedDark = Color(0xFF1F1F1F);
  static const fillDark = Color(0xFF303030);

  // The web app's text colours are translucent; these are flattened onto the
  // light and dark surfaces, so text over a map or photo doesn't take on the
  // colours behind.
  static const onSurfaceLight = Color(0xFF1F1F1F);
  static const onSurfaceVariantLight = Color(0xFF595959);
  static const onSurfaceDark = Color(0xFFDCDCDC);
  static const onSurfaceVariantDark = Color(0xFFADADAD);
}
