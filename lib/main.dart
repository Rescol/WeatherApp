import 'package:flutter/material.dart';
import 'package:weather_app/WeatherBloc.dart';
import 'package:weather_app/WeatherModel.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/WeatherJson.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[900],
          body: BlocProvider(
            builder: (context) => WeatherBloc(WeatherJson()),
            child: SearchPage(),
          ),
        ));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Column(
      children: <Widget>[
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherIsNotSearched)
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Прогноз погоды",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white70,
                                  style: BorderStyle.solid)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid)),
                          hintText: "Введите название города",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          color: Colors.lightBlue,
                          child: Text(
                            "Поиск",
                            style:
                            TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            else if (state is WeatherIsLoading)
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ));
            else if (state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            else return Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Город не найден!",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                          },
                          color: Colors.lightBlue,
                          child: Text(
                            "Поиск",
                            style:
                            TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
          },
        )
      ],
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/road.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              city,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weather.getTemp.round().toString() + "°C",
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
            Text(
              "Ощущается: " + weather.getFeels_like.round().toString() + "°C",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 90),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        weather.getMinTemp.round().toString() + "°C",
                        style: TextStyle(color: Colors.white70, fontSize: 30),
                      ),
                      Text(
                        "Мин Температура",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 90),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        weather.getMaxTemp.round().toString() + "°C",
                        style: TextStyle(color: Colors.white70, fontSize: 30),
                      ),
                      Text(
                        "Макс Температура",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 90),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        weather.getPressure.round().toString() + " ММ",
                        style: TextStyle(color: Colors.white70, fontSize: 30),
                      ),
                      Text(
                        "Давление",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(40, 40, 40, 100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        weather.getHumidity.round().toString() + "%",
                        style: TextStyle(color: Colors.white70, fontSize: 30),
                      ),
                      Text(
                        "Влажность",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.only(top: 10.0),
              child: FloatingActionButton(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.search),
                onPressed: () {
                  BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
