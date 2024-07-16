import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/RepeatedFuncs/slider.dart';
import 'package:movie_app/apikey/apii.dart';
class Tvseries extends StatefulWidget {
  @override
  State<Tvseries> createState() => _TvseriesState();
}

class _TvseriesState extends State<Tvseries> {
  List<Map<String, dynamic>> popularTvseries = [];
  List<Map<String, dynamic>> onairTvseries = [];
  List<Map<String, dynamic>> topTvseries = [];

  var popularTvseriesurl =
      'https://api.themoviedb.org/3/tv/popular?api_key=$apikey';

  var onairtvseriesurl =
      'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey';

  var topratedtvseriesurl =
      'https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey';

  Future<void> tvseriesFunction() async {
    var populartvrespone = await http.get(Uri.parse(popularTvseriesurl));

    if (populartvrespone.statusCode == 200) {
      var temp = jsonDecode(populartvrespone.body);
      var poptvjson = temp['results'];

      for (var i = 0; i < poptvjson.length; i++) {
        popularTvseries.add({
          "name": poptvjson[i]['name'],
          "poster_path": poptvjson[i]['poster_path'],
          "vote_average": poptvjson[i]['vote_average'],
          "Date": poptvjson[i]['first_air_date'],
          "id": poptvjson[i]['id'],
        });
      }
    } else {
      print(populartvrespone.statusCode);
    }
//////////////////////////////////////////////////////////////////////////////////////////
    var onairtvrespone = await http.get(Uri.parse(onairtvseriesurl));

    if (onairtvrespone.statusCode == 200) {
      var temp = jsonDecode(onairtvrespone.body);
      var onairtvjson = temp['results'];

      for (var i = 0; i < onairtvjson.length; i++) {
          onairTvseries.add({
          "name": onairtvjson[i]['name'],
          "poster_path": onairtvjson[i]['poster_path'],
          "vote_average": onairtvjson[i]['vote_average'],
          "Date": onairtvjson[i]['first_air_date'],
          "id": onairtvjson[i]['id'],
        });
      }
    } else {
      print(onairtvrespone.statusCode);
    }
//////////////////////////////////////////////////////////////////////////////////////////
    var toptvrespone = await http.get(Uri.parse(topratedtvseriesurl));

    if (toptvrespone.statusCode == 200) {
      var temp = jsonDecode(toptvrespone.body);
      var toptvjson = temp['results'];

      for (var i = 0; i < toptvjson.length; i++) {
        topTvseries.add({
          "name": toptvjson[i]['name'],
          "poster_path": toptvjson[i]['poster_path'],
          "vote_average": toptvjson[i]['vote_average'],
          "Date": toptvjson[i]['first_air_date'],
          "id": toptvjson[i]['id'],
        });
      }
    } else {
      print(toptvrespone.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tvseriesFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Sliderlist(topTvseries, 'Top Rated Tv series', "tv", 20),
              Sliderlist(popularTvseries, 'Popular Tv series', "tv", 20),
              Sliderlist(onairTvseries, 'Currently Streaming', "tv", 20)
            ],
          );
          }
      },
    );
  }
}
