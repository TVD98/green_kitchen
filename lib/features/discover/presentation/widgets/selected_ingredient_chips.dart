import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

class SelectedIngredientChips extends StatelessWidget {
  const SelectedIngredientChips({
    super.key,
    required this.ingredients,
    required this.onRemove,
  });

  final List<String> ingredients;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: AppSpacing.gap8,
      runSpacing: AppSpacing.gap8,
      children: [
        for (final ingredient in ingredients)
          InputChip(
            label: Text(ingredient),
            onDeleted: () => onRemove(ingredient),
            deleteIconColor: AppColors.brand,
          ),
      ],
    );
  }
}
