part of 'pantry_bloc.dart';

sealed class PantryEvent extends Equatable {
  const PantryEvent();

  @override
  List<Object?> get props => [];
}

final class PantryStarted extends PantryEvent {
  const PantryStarted();
}

final class PantryRetried extends PantryEvent {
  const PantryRetried();
}
