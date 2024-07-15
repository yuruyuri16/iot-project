part of 'sns_data_bloc.dart';

sealed class SnsDataEvent {
  const SnsDataEvent();
}

final class SnsDataSubscriptionRequested extends SnsDataEvent {
  const SnsDataSubscriptionRequested();
}
