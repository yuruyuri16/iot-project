part of 'sns_graph_bloc.dart';

final class SnsGraphState extends Equatable {
  const SnsGraphState({
    this.data = const [],
  });

  final List<Climate> data;

  @override
  List<Object> get props => [data];

  SnsGraphState copyWith({
    List<Climate>? data,
  }) {
    return SnsGraphState(
      data: data ?? this.data,
    );
  }
}
