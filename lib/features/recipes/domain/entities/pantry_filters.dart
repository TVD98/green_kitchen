import 'package:equatable/equatable.dart';

class PantryFilters extends Equatable {
  const PantryFilters({this.maxTime, this.difficulty, this.tags = const []});

  final int? maxTime;
  final String? difficulty;
  final List<String> tags;

  PantryFilters copyWith({
    int? maxTime,
    String? difficulty,
    List<String>? tags,
    bool clearMaxTime = false,
    bool clearDifficulty = false,
  }) {
    return PantryFilters(
      maxTime: clearMaxTime ? null : (maxTime ?? this.maxTime),
      difficulty:
          clearDifficulty ? null : (difficulty ?? this.difficulty),
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [maxTime, difficulty, tags];
}

class RecipeSearchQuery extends Equatable {
  const RecipeSearchQuery({
    this.q,
    this.maxTime,
    this.difficulty,
    this.tags = const [],
  });

  final String? q;
  final int? maxTime;
  final String? difficulty;
  final List<String> tags;

  @override
  List<Object?> get props => [q, maxTime, difficulty, tags];
}

class DiscoverySearchQuery extends Equatable {
  const DiscoverySearchQuery({
    required this.prompt,
    this.usePreferences = false,
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
