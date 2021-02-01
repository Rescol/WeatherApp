import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/WeatherModel.dart';

class WeatherJson{
  Future<WeatherModel> getWeather(String city) async{
    final result = await http.Client().get("https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=8092420cf9754aeae0410afedc57e4f8&units=metric");

    if(result.statusCode != 200)
      throw Exception();

    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final response){
    final jsonDecoded = json.decode(response);

    final jsonWeather = jsonDecoded["main"];

    return WeatherModel.fromJson(jsonWeather);
  }
}