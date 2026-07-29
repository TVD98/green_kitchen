import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';
import '../../../suggestions/domain/utils/mock_popularity.dart';

part 'suggestions_event.dart';
part 'suggestions_state.dart';

class SuggestionSection extends Equatable {
  const SuggestionSection({
    required this.key,
    required this.recipes,
    this.showMockViews = false,
  });

  final String key;
  final List<Recipe> recipes;
  final bool showMockViews;

  @override
  List<Object?> get props => [key, recipes, showMockViews];
}

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  SuggestionsBloc({required SearchRecipes searchRecipes})
      : _searchRecipes = searchRecipes,
        super(const SuggestionsState()) {
    on<SuggestionsStarted>(_onStarted);
  }

  final SearchRecipes _searchRecipes;

  Future<void> _onStarted(
    SuggestionsStarted event,
    Emitter<SuggestionsState> emit,
  ) async {
    emit(state.copyWith(status: SuggestionsStatus.loading));
    try {
      final featured = await _searchRecipes(const RecipeSearchQuery());
      final popular = await _searchRecipes(const RecipeSearchQuery());
      final quick = await _searchRecipes(
        const RecipeSearchQuery(maxTime: 30),
      );
      final easy = await _searchRecipes(
        const RecipeSearchQuery(difficulty: 'easy'),
      );

      Failure? failure;
      final sections = <SuggestionSection>[];

      void addSection(
        String key,
        Result<List<Recipe>> result, {
        bool showMockViews = false,
        int take = 5,
      }) {
        result.fold(
          (f) => failure ??= f,
          (recipes) {
            if (recipes.isNotEmpty) {
              sections.add(
                SuggestionSection(
                  key: key,
                  recipes: recipes.take(take).toList(growable: false),
                  showMockViews: showMockViews,
                ),
              );
            }
          },
        );
      }

      addSection('featured', featured, take: 1);
      addSection('popular', popular, showMockViews: true);
      addSection('quick', quick);
      addSection('easy', easy);

      if (failure != null && sections.isEmpty) {
        emit(
          state.copyWith(
            status: SuggestionsStatus.failure,
            failure: failure,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: SuggestionsStatus.success,
          sections: sections,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SuggestionsStatus.failure,
          failure: const ServerFailure(),
        ),
      );
    }
  }
}

int mockViewsFor(Recipe recipe) => mockViewCountForRecipe(recipe);
