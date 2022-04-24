import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/Data/weather_model.dart';

class WeatherFetch1D {
  Future<WeatherResponse> getWeather(String city) async {
    final queryParameters = {
      'q': city,
      'appid': 'a4cc3b2848f5a275fa200b16eae19a6b',
      'units': 'metric',
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}

class WeatherFetch5D {
  Future<WeatherResponse5D> getWeather(String city) async {
    final queryParameters = {
      'q': city,
      'appid': 'a4cc3b2848f5a275fa200b16eae19a6b',
      'units': 'metric',
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/forecast', queryParameters);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    return WeatherResponse5D.fromJson(json);
  }
}

class WeatherFetchCities {
  Future<List<WeatherResponseFavorite>> getWeather(List<String> Cities) async {
    List<WeatherResponseFavorite> weatherFetch = [];
    for (var city in Cities) {
      final queryParameters = {
        'q': city,
        'appid': 'a4cc3b2848f5a275fa200b16eae19a6b',
        'units': 'metric',
      };

      final uri = Uri.https(
          'api.openweathermap.org', '/data/2.5/weather', queryParameters);
      final response = await http.get(uri);
      final json = jsonDecode(response.body);
      weatherFetch.add(WeatherResponseFavorite.fromJson(json));
    }
    return weatherFetch;
  }
}
