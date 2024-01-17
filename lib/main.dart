import 'package:bloc_open_weather/blocs/temp_settings/temp_settings_bloc.dart';
import 'package:bloc_open_weather/blocs/theme/theme_bloc.dart';
import 'package:bloc_open_weather/blocs/weather/weather_bloc.dart';
import 'package:bloc_open_weather/pages/home_pages.dart';
import 'package:bloc_open_weather/repositories/weather_repository.dart';
import 'package:bloc_open_weather/services/weather_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiServices: WeatherApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsBloc>(
            create: (context) => TempSettingsBloc(),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          )
        ],
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            final temp = state.weather.temp;

            context.read<ThemeBloc>().add(ThemeChangeEvent(temp: temp));
          },
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Weather app',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      brightness: state.appTheme == AppTheme.light
                          ? Brightness.light
                          : Brightness.dark),
                  useMaterial3: true,
                ),
                home: const HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
