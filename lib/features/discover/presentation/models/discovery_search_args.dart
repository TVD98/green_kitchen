import 'package:equatable/equatable.dart';

import '../../../recipes/domain/entities/pantry_filters.dart';

class DiscoverySearchArgs extends Equatable {
  const DiscoverySearchArgs({
    required this.prompt,
    this.usePreferences = true,
    this.excludeAllergies = false,
    this.filters = const PantryFilters(),
  });

  final String prompt;
  final bool usePreferences;
  final bool excludeAllergies;
  final PantryFilters filters;

  @override
  List<Object?> get props => [
        prompt,
        usePreferences,
        excludeAllergies,
        filters,
      ];
}
