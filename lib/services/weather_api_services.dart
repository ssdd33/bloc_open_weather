import 'dart:convert';

import 'package:bloc_open_weather/constants/constants.dart';
import 'package:bloc_open_weather/exceptions/weather_exception.dart';
import 'package:bloc_open_weather/models/direct_geocoding.dart';
import 'package:bloc_open_weather/models/weather.dart';
import 'package:bloc_open_weather/services/http_error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherApiServices {
  final http.Client httpClient;

  WeatherApiServices({required this.httpClient});

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: 'geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APPID'],
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException('cannot get the location of $city');
      }

      final directGeocoding = DirectGeocoding.fromJson(responseBody);
      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: '/data/2.5/weather',
        queryParameters: {
          'lat': '${directGeocoding.lat}',
          'lon': '${directGeocoding.lon}',
          'units': kUnit,
          'appid': dotenv.env['APPID']
        });

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException('cannot get weather of ${directGeocoding.name}');
      }

      final weather = Weather.fromJson(responseBody);
      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
