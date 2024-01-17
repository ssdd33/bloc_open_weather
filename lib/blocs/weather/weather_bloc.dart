import 'package:bloc/bloc.dart';
import 'package:bloc_open_weather/models/custom_error.dart';
import 'package:bloc_open_weather/models/weather.dart';
import 'package:bloc_open_weather/repositories/weather_repository.dart';
import 'package:equatable/equatable.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({
    required this.weatherRepository,
  }) : super(WeatherState.initial()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(state.copyWith(status: WeatherStatus.loading));

      try {
        final Weather weather =
            await weatherRepository.fetchWeather(event.city);

        emit(state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ));

        print('state : $state');
      } on CustomError catch (e) {
        emit(state.copyWith(
          status: WeatherStatus.error,
          error: e,
        ));

        print('state : $state');
      }
    });
  }
}
