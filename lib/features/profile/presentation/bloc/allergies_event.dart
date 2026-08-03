part of 'allergies_bloc.dart';

sealed class AllergiesEvent extends Equatable {
  const AllergiesEvent();

  @override
  List<Object?> get props => [];
}

final class AllergiesStarted extends AllergiesEvent {
  const AllergiesStarted({this.lang = 'vi'});

  final String lang;

  @override
  List<Object?> get props => [lang];
}

final class AllergiesRetried extends AllergiesEvent {
  const AllergiesRetried({this.lang = 'vi'});

  final String lang;

  @override
  List<Object?> get props => [lang];
}

final class AllergiesQueryChanged extends AllergiesEvent {
  const AllergiesQueryChanged(this.query, {this.lang = 'vi'});

  final String query;
  final String lang;

  @override
  List<Object?> get props => [query, lang];
}

final class AllergiesSearchRequested extends AllergiesEvent {
  const AllergiesSearchRequested(this.query, {this.lang = 'vi'});

  final String query;
  final String lang;

  @override
  List<Object?> get props => [query, lang];
}

final class AllergiesToggled extends AllergiesEvent {
  const AllergiesToggled(this.allergy);

  final UserAllergy allergy;

  @override
  List<Object?> get props => [allergy];
}

final class AllergiesCleared extends AllergiesEvent {
  const AllergiesCleared();
}

final class AllergiesSaveRequested extends AllergiesEvent {
  const AllergiesSaveRequested();
}
