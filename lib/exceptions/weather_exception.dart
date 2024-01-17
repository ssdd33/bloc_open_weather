class WeatherException implements Exception {
  String msg;

  WeatherException([this.msg = 'something went wrong']) {
    msg = 'Weather Exception : $msg';
  }

  @override
  String toString() => msg;
}
