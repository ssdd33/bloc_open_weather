import 'package:bloc/bloc.dart';
import 'package:bloc_open_weather/constants/constants.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeChangeEvent>((event, emit) async {
      emit(state.copyWith(
          appTheme: event.temp >= kWarmOrNot ? AppTheme.light : AppTheme.dark));
    });
  }
}
