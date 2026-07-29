part of 'discovery_results_bloc.dart';

enum DiscoveryResultsStatus { initial, loading, success, empty, failure }

final class DiscoveryResultsState extends Equatable {
  const DiscoveryResultsState({
    this.status = DiscoveryResultsStatus.initial,
    this.recipes = const [],
    this.failure,
  });

  final DiscoveryResultsStatus status;
  final List<Recipe> recipes;
  final Failure? failure;

  DiscoveryResultsState copyWith({
    DiscoveryResultsStatus? status,
    List<Recipe>? recipes,
    Failure? failure,
  }) {
    return DiscoveryResultsState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, recipes, failure];
}
