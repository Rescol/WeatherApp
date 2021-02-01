import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/WeatherModel.dart';
import 'package:weather_app/WeatherJson.dart';

class WeatherEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class FetchWeather extends WeatherEvent{
  final _city;

  FetchWeather(this._city);

  @override
  List<Object> get props => [_city];
}

class ResetWeather extends WeatherEvent{

}

class WeatherState extends Equatable{
  @override
  List<Object> get props => [];

}


class WeatherIsNotSearched extends WeatherState{

}

class WeatherIsLoading extends WeatherState{

}

class WeatherIsLoaded extends WeatherState{
  final _weather;

  WeatherIsLoaded(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState{

}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState>{

  WeatherJson weatherRepo;

  WeatherBloc(this.weatherRepo);

  @override
  WeatherState get initialState => WeatherIsNotSearched();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async*{
    if(event is FetchWeather){
      yield WeatherIsLoading();

      try{
        WeatherModel weather = await weatherRepo.getWeather(event._city);
        yield WeatherIsLoaded(weather);
      }on Exception catch(e){
        print(e);
        yield WeatherIsNotLoaded();
      }
    }else if(event is ResetWeather){
      yield WeatherIsNotSearched();
    }
  }

}
