import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_repository/sns_repository.dart';

part 'sns_data_event.dart';
part 'sns_data_state.dart';

class SnsDataBloc extends Bloc<SnsDataEvent, SnsDataState> {
  SnsDataBloc({
    required SnsRepository snsRepository,
  })  : _snsRepository = snsRepository,
        super(const SnsDataState()) {
    on<SnsDataSubscriptionRequested>(_onSubscriptionRequested);
  }

  final SnsRepository _snsRepository;

  Future<void> _onSubscriptionRequested(
    SnsDataSubscriptionRequested event,
    Emitter<SnsDataState> emit,
  ) async {
    emit(state.copyWith(status: SnsDataStatus.loading));
    await emit.forEach(
      _snsRepository.sensorData,
      onData: (climate) => state.copyWith(
        temperature: climate.temperature,
        humidity: climate.humidity,
        status: SnsDataStatus.success,
      ),
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state.copyWith(status: SnsDataStatus.failure);
      },
    );
  }
}
