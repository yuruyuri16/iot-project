import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_repository/sns_repository.dart';

part 'sns_graph_event.dart';
part 'sns_graph_state.dart';

class SnsGraphBloc extends Bloc<SnsGraphEvent, SnsGraphState> {
  SnsGraphBloc({
    required SnsRepository snsRepository,
  })  : _snsRepository = snsRepository,
        super(const SnsGraphState()) {
    on<SnsGraphEvent>(
      (event, emit) async => switch (event) {
        SnsGraphFetchData() => _onFetchData(event, emit),
        SnsGraphSubscriptionRequested() =>
          _onSubscriptionRequested(event, emit),
      },
      transformer: sequential(),
    );
  }

  final SnsRepository _snsRepository;

  Future<void> _onFetchData(
    SnsGraphFetchData event,
    Emitter<SnsGraphState> emit,
  ) async {
    try {
      print('fetching');
      final data = await _snsRepository.getSensorData();
      print('got data $data');
      emit(state.copyWith(data: data));
    } catch (error, stackTrace) {
      print(error);
      addError(error, stackTrace);
    }
  }

  Future<void> _onSubscriptionRequested(
    SnsGraphSubscriptionRequested event,
    Emitter<SnsGraphState> emit,
  ) async {
    await emit.forEach(
      _snsRepository.sensorData,
      onData: (climate) => state.copyWith(
        data: [...state.data, climate],
      ),
    );
  }
}
