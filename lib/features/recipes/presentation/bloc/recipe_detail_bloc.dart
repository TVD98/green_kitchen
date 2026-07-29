import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  RecipeDetailBloc({
    required GetRecipeById getRecipeById,
    required RecordRecipeViewed recordRecipeViewed,
    required ToggleRecipeSaved toggleRecipeSaved,
    required IsRecipeSaved isRecipeSaved,
    required String recipeId,
  })  : _getRecipeById = getRecipeById,
        _recordRecipeViewed = recordRecipeViewed,
        _toggleRecipeSaved = toggleRecipeSaved,
        _isRecipeSaved = isRecipeSaved,
        _recipeId = recipeId,
        super(const RecipeDetailState()) {
    on<RecipeDetailStarted>(_onStarted);
    on<RecipeDetailSaveToggled>(_onSaveToggled);
  }

  final GetRecipeById _getRecipeById;
  final RecordRecipeViewed _recordRecipeViewed;
  final ToggleRecipeSaved _toggleRecipeSaved;
  final IsRecipeSaved _isRecipeSaved;
  final String _recipeId;

  Future<void> _onStarted(
    RecipeDetailStarted event,
    Emitter<RecipeDetailState> emit,
  ) async {
    emit(state.copyWith(status: RecipeDetailStatus.loading));
    final saved = await _isRecipeSaved(_recipeId);
    final result = await _getRecipeById(_recipeId);
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: failure is NotFoundFailure
                ? RecipeDetailStatus.notFound
                : RecipeDetailStatus.failure,
            failure: failure,
            isSaved: saved,
          ),
        );
      },
      (recipe) async {
        await _recordRecipeViewed(_recipeId);
        emit(
          state.copyWith(
            status: RecipeDetailStatus.success,
            recipe: recipe,
            isSaved: saved,
          ),
        );
      },
    );
  }

  Future<void> _onSaveToggled(
    RecipeDetailSaveToggled event,
    Emitter<RecipeDetailState> emit,
  ) async {
    final saved = await _toggleRecipeSaved(_recipeId);
    emit(state.copyWith(isSaved: saved));
  }
}
