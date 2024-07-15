import 'package:bloc/bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.realTimeClimate);

  void setTab(int selectedTab) {
    emit(HomeState.values[selectedTab]);
  }
}