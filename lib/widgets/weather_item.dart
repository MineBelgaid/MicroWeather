// ignore_for_file: prefer_const_constructors,prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/Data/weather_fetch.dart';
import 'package:weather_app/Data/weather_model.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherItem extends StatefulWidget {
  const WeatherItem({
    required this.cityName,
  });

  final String cityName;

  @override
  State<WeatherItem> createState() => _WeatherItemState();
}

class _WeatherItemState extends State<WeatherItem> {
  String iconMain = 'http://openweathermap.org/img/wn/10d@4x.png';
  // late String cityNameMain;
  int temperatureMain = 1;
  int humidityMain = 1;
  double windMain = 1;
  double pressureMain = 1;
  String descriptionMain = 'clear sky';
  // String cityName = 'tlemcen';
  final _weatherFetch5D = WeatherFetch5D();
  final _weatherFetch1D = WeatherFetch1D();
  final List<WeatherResponse> _response1D = [];
  final List<WeatherResponse5D> _response5D = [];
  List<Day> days = [];
  List<Hour> hours = [];

  Future<void> search() async {
    final response1 = await _weatherFetch1D.getWeather(widget.cityName);
    final response = await _weatherFetch5D.getWeather(widget.cityName);
    setState(() {
      _response1D.isEmpty
          ? _response1D.add(response1)
          : _response1D[0] = response1;
      iconMain = _response1D.elementAt(0).iconURL;
      temperatureMain = _response1D.elementAt(0).temperature;
      humidityMain = _response1D.elementAt(0).humidity;
      windMain = _response1D.elementAt(0).windSpeed;
      pressureMain = _response1D.elementAt(0).pressure;
      descriptionMain = _response1D.elementAt(0).weather;

      _response5D.isEmpty
          ? _response5D.add(response)
          : _response5D[0] = response;
      days = _response5D.elementAt(0).days;
      hours = _response5D.elementAt(0).hours;
      for (var hour in hours) {
        images[hour.icon.toString()] = Image.asset(
          "assets/" + hour.icon + ".png",
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  Map<String, Image> images = {};
  @override
  Widget build(BuildContext context) {
    // cityNameMain = widget.cityName;
    search();
    return Container(
      color: Color(0xfffdfcf3),
      padding: EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              backgroundColor: Color(0xfffdfcf3),
              foregroundColor: Colors.orange,
              onPressed: () {

              },
              child: Icon(Icons.favorite),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.cityName,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(temperatureMain.toString() + "°",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.w500)),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        alignment: Alignment.center,
                        child: Text(descriptionMain,
                            style: TextStyle(fontSize: 18)),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 40),
                Image.network(
                  iconMain,
                  // scale: 2.0,
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                  // colorBlendMode: BlendMode.softLight,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxedIcon(
                WeatherIcons.raindrop,
                size: 17,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(humidityMain.toString() + "%",
                    style: TextStyle(fontSize: 15)),
              ),
              Expanded(child: SizedBox()),
              BoxedIcon(
                WeatherIcons.time_12,
                size: 17,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(pressureMain.toString(),
                    style: TextStyle(fontSize: 15)),
              ),
              Expanded(child: SizedBox()),
              BoxedIcon(WeatherIcons.strong_wind),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(windMain.toString() + "km/h",
                    style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text("Today",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hours.isEmpty ? 5 : hours.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: HourWidget(
                    imageUrl: hours.isEmpty ? '02d' : hours[index].icon,
                    text: hours.isNotEmpty ? hours[index].time.toString() : "0",
                    temp: hours.isEmpty
                        ? "0"
                        : hours[index].temperature.toString(),
                  ));
                }),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: days.isEmpty ? 0 : days.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // color: Color(0xfffdfcf3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(days.isEmpty ? "day" : days.elementAt(index).day,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      Expanded(child: SizedBox()),
                      Container(
                        height: 40,
                        child: Image.asset(
                          days.isEmpty
                              ? "assets/10d.png"
                              : "assets/" + days.elementAt(index).weatherIcon + ".png",
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),

                      // BoxedIcon(WeatherIcons.day_cloudy, size: 17),
                      Expanded(child: SizedBox()),
                      Text(
                          days.isEmpty
                              ? "19°"
                              : days.elementAt(index).temperature_max.toString() + "°",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                          days.isEmpty
                              ? "19°"
                              : days.elementAt(index).temperature_min.toString() + "°",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HourWidget extends StatefulWidget {
  const HourWidget(
      {Key? key,
      required this.imageUrl,
      required this.text,
      required this.temp})
      : super(key: key);
  final String text;
  final String imageUrl;
  final String temp;

  @override
  State<HourWidget> createState() => _HourWidgetState();
}

class _HourWidgetState extends State<HourWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        // color: Colors.white,
      ),
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.text, style: TextStyle(fontSize: 15)),
          Container(
            // height: 40,
            width: 70,
            height: 60,
            child: Image.asset(
              "assets/" + widget.imageUrl + ".png",
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
          ),
          Text(widget.temp, style: TextStyle(fontSize: 17)),
        ],
      ),
    );
  }
}
