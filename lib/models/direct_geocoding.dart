import 'package:equatable/equatable.dart';

class DirectGeocoding extends Equatable {
  final String name;
  final double lon;
  final double lat;
  final String country;

  const DirectGeocoding(
      {required this.name,
      required this.lat,
      required this.lon,
      required this.country});

  factory DirectGeocoding.fromJson(List<dynamic> json) {
    final Map<String, dynamic> data = json[0];

    return DirectGeocoding(
      name: data['name'],
      lat: data['lat'],
      lon: data['lon'],
      country: data['country'],
    );
  }
  @override
  List<Object> get props => [
        name,
        lon,
        lat,
      ];

  @override
  String toString() {
    return 'DirectGeocoding(name: $name, lon: $lon, lat: $lat, country: $country)';
  }
}
