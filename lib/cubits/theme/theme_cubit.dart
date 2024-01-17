import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_open_weather/constants/constants.dart';
import 'package:bloc_open_weather/cubits/weather/weather_cubit.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final WeatherCubit weatherCubit;
  late final StreamSubscription weatherSubscription;
  ThemeCubit({required this.weatherCubit}) : super(ThemeState.initial()) {
    weatherSubscription = weatherCubit.stream.listen((weatherState) {
      final temp = weatherState.weather.temp;

      emit(state.copyWith(
          appTheme: temp >= kWarmOrNot ? AppTheme.light : AppTheme.dark));
    });
  }

  @override
  Future<void> close() {
    weatherSubscription.cancel();
    return super.close();
  }
}
