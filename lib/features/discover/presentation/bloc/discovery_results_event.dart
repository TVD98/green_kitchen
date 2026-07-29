part of 'discovery_results_bloc.dart';

sealed class DiscoveryResultsEvent extends Equatable {
  const DiscoveryResultsEvent();

  @override
  List<Object?> get props => [];
}

final class DiscoveryResultsStarted extends DiscoveryResultsEvent {
  const DiscoveryResultsStarted();
}

final class DiscoveryResultsRetried extends DiscoveryResultsEvent {
  const DiscoveryResultsRetried();
}
