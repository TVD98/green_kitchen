import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  const Ingredient({
    required this.id,
    required this.canonicalName,
    required this.category,
    required this.aliases,
  });

  final String id;
  final String canonicalName;
  final String category;
  final List<String> aliases;

  @override
  List<Object?> get props => [id, canonicalName];
}
