// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({Key? key,
    required this.icon,
    required this.country,
    required this.city,
    required this.humidity,
    required this.temp,
    required this.wind,
  }) : super(key: key);

  



  final String icon;
  final String country;
  final String city;
  final String temp;
  final String wind;
  final String humidity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10),
      margin: EdgeInsets.only(top: 20, left: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(offset: Offset(0, 0), blurRadius: 0.1)]),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(temp, style: TextStyle(fontSize: 50)),
              Text(city, style: TextStyle(fontSize: 20)),
              Text(
                country,
                style: TextStyle(fontSize: 20, color: Colors.grey[300]),
              ),
              Row(
                children: [
                  Icon(Icons.water_drop_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text(humidity,
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GradientIcon(
              //     WeatherIcons.cloud,
              //     70,
              //     LinearGradient(colors: [
              //       Color(0xffFD434A),
              //       Color(0xffFCCC77),
              //     ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/"+icon+".png",
                height: 80,
                width: 80,
                fit: BoxFit.fill,
              ),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  BoxedIcon(WeatherIcons.strong_wind, size: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(wind+"km\h", style: TextStyle(fontSize: 15)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
