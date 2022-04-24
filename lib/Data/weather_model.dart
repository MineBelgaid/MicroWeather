/* 


*/
import 'package:intl/intl.dart';

class WeatherResponse {
  final String cityName;
  final String weather;
  final String weatherDescription;
  final String weatherIcon;
  final int temperature;
  final double pressure;
  final int humidity;
  final double windSpeed;
  String get iconURL {
    return "http://openweathermap.org/img/wn/${weatherIcon}@4x.png";
  }

  WeatherResponse(
      {required this.cityName,
      required this.weather,
      required this.weatherDescription,
      required this.weatherIcon,
      required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.windSpeed});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'];
    final weather = json['weather'][0]['main'];
    final weatherDescription = json['weather'][0]['description'];
    final weatherIcon =
        json['weather'][0]['icon'].toString().replaceAll("04d", "02d");
    final temperature = json['main']['temp'].toInt();
    final pressure = json['main']['pressure'].toDouble();
    final humidity = json['main']['humidity'];
    final windSpeed = json['wind']['speed'].toDouble();
    return WeatherResponse(
      cityName: cityName,
      weather: weather,
      weatherDescription: weatherDescription,
      weatherIcon: weatherIcon,
      temperature: temperature,
      pressure: pressure,
      humidity: humidity,
      windSpeed: windSpeed,
    );
  }
}

class WeatherResponse5D {
  final List<Day> days;
  final List<Hour> hours;
  final String cityName;

  WeatherResponse5D({
    required this.days,
    required this.cityName,
    required this.hours,
  });

  factory WeatherResponse5D.fromJson(Map<String, dynamic> json) {
    final List<Day> daysList = [];
    final List<Hour> hoursList = [];
    var currentdate =
        DateTime.fromMillisecondsSinceEpoch(json['list'][0]['dt'] * 1000);
    var currentdate1 = currentdate;
    // days.add(DateFormat('EEEE').format(currentdate));
    for (var i = 0; i < 10; i++) {
      var day = json['list'][i];
      var time = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
      hoursList.add(Hour.fromJson(day));
    }
    var midday = ['13', '12', '11'];
    for (var day in json['list']) {
      var time = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
      var dayName = DateFormat('EEEE').format(time);
      if (dayName != DateFormat('EEEE').format(currentdate) &&
          midday.contains(DateFormat("HH").format(time))) {
        currentdate = time;
        daysList.add(Day.fromJson(day));
      }
    }
    final cityName = json['city']['name'];
    return WeatherResponse5D(
      days: daysList,
      cityName: cityName,
      hours: hoursList,
    );
  }
}

String iconURL(String icon) {
  String url = "http://openweathermap.org/img/wn/${icon}@2x.png";
  url.replaceAll('n@2x', 'd@2x');
  return url;
}

class Day {
  final day;
  final weatherIcon;
  final temperature_min;
  final temperature_max;
  final String weather;
  final String weatherDescription;
  final int temperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  Day(
      {required this.day,
      required this.weatherIcon,
      required this.temperature_min,
      required this.temperature_max,
      required this.weather,
      required this.weatherDescription,
      required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.windSpeed});
  factory Day.fromJson(Map<String, dynamic> json) {
    var day = json['dt'];
    var dt = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    day = DateFormat('EEEE').format(dt);

    final weatherIcon = json['weather'][0]['icon'];
    final temperature_min = json['main']['temp_min'].toInt();

    final temperature_max = json['main']['temp_max'].toInt();

    final weather = json['weather'][0]['main'];
    final weatherDescription = json['weather'][0]['description'];
    final temperature = json['main']['temp'].toInt();
    final pressure = json['main']['pressure'].toInt();
    final humidity = json['main']['humidity'];
    final windSpeed = json['wind']['speed'].toDouble();
    return Day(
      day: day,
      weatherIcon: weatherIcon,
      temperature_min: temperature_min,
      temperature_max: temperature_max,
      weather: weather,
      weatherDescription: weatherDescription,
      temperature: temperature,
      pressure: pressure,
      humidity: humidity,
      windSpeed: windSpeed,
    );
  }
}

class Hour {
  final time;
  final icon;
  final temperature;

  Hour({
    required this.time,
    required this.icon,
    required this.temperature,
  });
  factory Hour.fromJson(Map<String, dynamic> json) {
    var day = json['dt'];
    var dt = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    final icon = json['weather'][0]['icon'];
    final temperature = json['main']['temp'].toInt();
    final hour = DateFormat('j').format(dt);
    return Hour(
      time: hour,
      icon: icon,
      temperature: temperature,
    );
  }
}

class WeatherResponseFavorite {
  final String cityName;
  final String country;
  final String weatherIcon;
  final int temperature;
  final int humidity;
  final double windSpeed;

  WeatherResponseFavorite({
    required this.cityName,
    required this.country,
    required this.weatherIcon,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherResponseFavorite.fromJson(Map<String, dynamic> json) {

    final cityName = json['name'];

    final weatherIcon =
        json['weather'][0]['icon'].toString().replaceAll("04d", "02d");
    final temperature = json['main']['temp'].toInt();

    final humidity = json['main']['humidity'];
    final windSpeed = json['wind']['speed'].toDouble();
    final country = json['sys']['country'];
    return WeatherResponseFavorite(
      country: country,
      cityName: cityName,
      weatherIcon: weatherIcon,
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
    );
  }
}
