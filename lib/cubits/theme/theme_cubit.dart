import 'package:bloc/bloc.dart';
import 'package:bloc_open_weather/constants/constants.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());
  changeAppTheme(double temp) {
    emit(state.copyWith(
        appTheme: temp >= kWarmOrNot ? AppTheme.light : AppTheme.dark));
  }
}
