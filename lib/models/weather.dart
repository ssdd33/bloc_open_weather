import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String description;
  final String icon;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String name;
  final DateTime lastUpdated;
  final String country;

  const Weather(
      {required this.description,
      required this.icon,
      required this.temp,
      required this.tempMin,
      required this.tempMax,
      required this.name,
      required this.country,
      required this.lastUpdated});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return Weather(
        description: weather['description'],
        icon: weather['icon'],
        temp: main['temp'],
        tempMin: main['tempMin'],
        tempMax: main['tempMax'],
        name: '',
        country: '',
        lastUpdated: DateTime.now());
  }
//nullable을 피하기 위한 초기 데이터, 다만 데이터를 사용할때 먼저 초기값인지 확인이 필요하다
  factory Weather.initial() {
    return Weather(
        description: '',
        icon: '',
        temp: 100,
        tempMin: 100,
        tempMax: 100,
        name: '',
        country: '',
        lastUpdated: DateTime(1970));
  }

  @override
  List<Object> get props {
    return [
      description,
      icon,
      temp,
      tempMin,
      tempMax,
      name,
      country,
      lastUpdated,
    ];
  }

  @override
  String toString() {
    return 'Weather(description: $description, icon: $icon, temp: $temp, tempMin: $tempMin, tempMax: $tempMax, name: $name, country: $country, lastUpdated: $lastUpdated)';
  }

  Weather copyWith({
    String? description,
    String? icon,
    double? temp,
    double? tempMin,
    double? tempMax,
    String? name,
    DateTime? lastUpdated,
    String? country,
  }) {
    return Weather(
      description: description ?? this.description,
      icon: icon ?? this.icon,
      temp: temp ?? this.temp,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      name: name ?? this.name,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      country: country ?? this.country,
    );
  }
}
