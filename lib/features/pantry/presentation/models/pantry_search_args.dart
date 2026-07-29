import 'package:equatable/equatable.dart';

import '../../../recipes/domain/entities/pantry_filters.dart';

class PantrySearchArgs extends Equatable {
  const PantrySearchArgs({
    required this.ingredients,
    this.filters = const PantryFilters(),
  });

  final List<String> ingredients;
  final PantryFilters filters;

  @override
  List<Object?> get props => [ingredients, filters];
}
