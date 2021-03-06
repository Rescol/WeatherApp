class WeatherModel{
  final temp;
  final pressure;
  final humidity;
  final temp_max;
  final temp_min;
  final feels_like;

  double get getTemp => temp -0.0;
  double get getMaxTemp => temp_max -0.0;
  double get getMinTemp => temp_min -0.0;
  double get getPressure => pressure -0.0;
  double get getHumidity => humidity -0.0;
  double get getFeels_like => feels_like -0.0;

  WeatherModel(this.temp, this.pressure, this.humidity, this.temp_max, this.temp_min, this.feels_like);

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
      json["temp"],
      json["pressure"],
      json["humidity"],
      json["temp_max"],
      json["temp_min"],
      json["feels_like"],
    );
  }
}