import 'package:flutter/material.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';

@immutable
final class AppExtraColors extends ThemeExtension<AppExtraColors> {
  const new({
    required this.brand,
    required this.seasonSummer,
    required this.seasonWinter,
  });

  static const light = AppExtraColors(
    brand: AppColors.brand,
    seasonSummer: AppColors.seasonSummerLight,
    seasonWinter: AppColors.seasonWinterLight,
  );

  static const dark = AppExtraColors(
    brand: AppColors.brand,
    seasonSummer: AppColors.seasonSummerDark,
    seasonWinter: AppColors.seasonWinterDark,
  );

  final Color brand;
  final Color seasonSummer;
  final Color seasonWinter;

  @override
  AppExtraColors copyWith({
    Color? brand,
    Color? seasonSummer,
    Color? seasonWinter,
  }) => AppExtraColors(
    brand: brand ?? this.brand,
    seasonSummer: seasonSummer ?? this.seasonSummer,
    seasonWinter: seasonWinter ?? this.seasonWinter,
  );

  @override
  AppExtraColors lerp(AppExtraColors? other, double t) {
    if (other == null) return this;
    return AppExtraColors(
      brand: Color.lerp(brand, other.brand, t)!,
      seasonSummer: Color.lerp(seasonSummer, other.seasonSummer, t)!,
      seasonWinter: Color.lerp(seasonWinter, other.seasonWinter, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppExtraColors &&
      other.brand == brand &&
      other.seasonSummer == seasonSummer &&
      other.seasonWinter == seasonWinter;

  @override
  int get hashCode => Object.hash(brand, seasonSummer, seasonWinter);
}
