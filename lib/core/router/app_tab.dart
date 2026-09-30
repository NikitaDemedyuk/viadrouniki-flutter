import 'package:flutter/material.dart';
import 'package:viadrouniki/core/l10n/gen/app_localizations.dart';

/// The bottom navigation tabs, in the order of the shell's branches.
enum AppTab {
  trips(
    path: '/trips',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
  ),
  points(
    path: '/attractions',
    icon: Icons.place_outlined,
    selectedIcon: Icons.place,
  ),
  cars(
    path: '/cars',
    icon: Icons.directions_car_outlined,
    selectedIcon: Icons.directions_car,
  ),
  profile(
    path: '/profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  );

  new({required this.path, required this.icon, required this.selectedIcon});

  static const AppTab start = trips;

  final String path;
  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) => switch (this) {
    AppTab.trips => l10n.tabTrips,
    AppTab.points => l10n.tabPoints,
    AppTab.cars => l10n.tabCars,
    AppTab.profile => l10n.tabProfile,
  };
}
