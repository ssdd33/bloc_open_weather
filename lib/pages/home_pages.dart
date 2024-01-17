import 'package:bloc_open_weather/blocs/temp_settings/temp_settings_bloc.dart';
import 'package:bloc_open_weather/blocs/weather/weather_bloc.dart';
import 'package:bloc_open_weather/constants/constants.dart';
import 'package:bloc_open_weather/pages/search_page.dart';
import 'package:bloc_open_weather/pages/settings_page.dart';
import 'package:bloc_open_weather/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('weather'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                _city = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ));

                print('_city : $_city');

                if (_city != null) {
                  context
                      .read<WeatherBloc>()
                      .add(FetchWeatherEvent(city: _city!));
                }
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                icon: const Icon(Icons.settings)),
          ],
        ),
        body: _showWeather());
  }

  String showTemperature(double temp) {
    final tempUnit = context.watch<TempSettingsBloc>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return '${((temp * 5 / 9) + 32).toStringAsFixed(2)}℉';
    }
    return '${temp.toStringAsFixed(2)}℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String desc) {
    final formattedString = desc.titleCase;

    return Text(
      formattedString,
      style: const TextStyle(
        fontSize: 24,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state.status == WeatherStatus.initial) {
        return const Center(child: Text('select a city'));
      }
      if (state.status == WeatherStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.status == WeatherStatus.error && state.weather.name == '') {
        return const Center(child: Text("select a city"));
      }

      return ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 6),
          Text(
            state.weather.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TimeOfDay.fromDateTime(state.weather.lastUpdated)
                    .format(context),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              Text(
                '(${state.weather.country})',
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showTemperature(state.weather.temp),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(showTemperature(state.weather.tempMin),
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(showTemperature(state.weather.tempMax),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Spacer(),
              showIcon(state.weather.icon),
              Expanded(flex: 3, child: formatText(state.weather.description)),
              const Spacer(),
            ],
          )
        ],
      );
    }, listener: (context, state) {
      if (state.status == WeatherStatus.error) {
        errorDialog(context, state.error.errMsg);
      }
    });
  }
}
