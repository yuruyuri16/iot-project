part of 'sns_graph_bloc.dart';

sealed class SnsGraphEvent extends Equatable {
  const SnsGraphEvent();

  @override
  List<Object> get props => [];
}

final class SnsGraphFetchData extends SnsGraphEvent {
  const SnsGraphFetchData();
}

final class SnsGraphSubscriptionRequested extends SnsGraphEvent {
  const SnsGraphSubscriptionRequested();
}
