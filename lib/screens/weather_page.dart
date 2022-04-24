// ignore_for_file: prefer_const_constructors,prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/Data/weather_fetch.dart';
import 'package:weather_app/Data/weather_model.dart';
import 'package:weather_app/widgets/weather_widget.dart';
import 'package:weather_app/widgets/weather_item.dart';

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final screenWidgets = [];
  final _citeNameController = TextEditingController();
  String cityName = 'Tlemcen';
  final _weatherFetchFAv = WeatherFetchCities();
  final _weatherFetch = WeatherFetch1D();
  List<WeatherResponse> _response = [];
  List<WeatherResponseFavorite> _responseFav = [];
  Future<void> search() async {
    final response = await _weatherFetch.getWeather(cityName);
    setState(() =>
        _response.isEmpty ? _response.add(response) : _response[0] = response);
    setState(() {
      _citeNameController.text = '';
    });
  }

  List<dynamic> favorits = [];
  List<String> cities = ['Tlemcen', 'Oran', 'Alger'];
  // write to local json file


  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
  Future<void> LoadCities() async {



    final responsefav =
        await _weatherFetchFAv.getWeather(cities);
    for (var item in responsefav) {
      favorits.add({
        'city': item.cityName,
        'country': item.country,
        'temp': item.temperature,
        'icon': item.weatherIcon,
        'humidity': item.humidity,
        'wind': item.windSpeed,
      });
    }
    print(favorits);
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    search();
    LoadCities();
  }

  // Getting long and lat for hourly forcast
  final ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  @override
  void dispose() {
    super.dispose();
    _citeNameController.dispose();
    _notifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Color(0xfffdfcf3),
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      cityName = value;
                      _notifier.value++;
                      search();
                    });
                  },
                  controller: _citeNameController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // clear the search field
                          _citeNameController.clear();
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            )),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                // color: Colors.blue,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_outline,
                  // color: Colors.blue,
                ),
                label: "Favourites"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                  // color: Colors.blue,
                ),
                label: "settings"),
          ],
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          unselectedFontSize: 16,
          selectedIconTheme:
              IconThemeData(color: Color(0xff2E3151), opacity: 1.0, size: 30.0),
          selectedItemColor: Color(0xff2E3151),
          unselectedItemColor: Color(0xffDCC4AC),
          unselectedIconTheme:
              IconThemeData(color: Color(0xffDCC4AC), opacity: 1.0, size: 30.0),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (BuildContext context, int value, Widget? child) {
                  return new WeatherItem(cityName: cityName);
                }),
            Container(
              color: Color(0xfffdfcf3),
              child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [],
                ),
                Flexible(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: favorits.isEmpty ? 0 : favorits.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _changeIndex(1);
                        },
                        child: WeatherWidget(
                          // icon: "02d",
                          icon: favorits[index]['icon'].toString(),
                          country: favorits[index]['country'].toString(),
                          city: favorits[index]['city'].toString(),
                          humidity: favorits[index]['humidity'].toString(),
                          temp: favorits[index]['temp'].toString(),
                          wind: favorits[index]['wind'].toString(),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
