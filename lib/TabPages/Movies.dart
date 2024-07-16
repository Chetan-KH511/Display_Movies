import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/RepeatedFuncs/slider.dart';
import 'package:movie_app/apikey/apii.dart';
class Movies extends StatefulWidget {
  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List<Map<String, dynamic>> popmovielist = [];
  List<Map<String, dynamic>> onairmovseries = [];
  List<Map<String, dynamic>> topmovies = [];

  var popularmoviesurl =
      'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';

  var nowplayingmoviesurl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey';

  var topratedmoviesurl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey';

  
  
  Future<void> mpvieFunvtion() async {
    var popmoviesresponse = await http.get(Uri.parse(popularmoviesurl));

    if (popmoviesresponse.statusCode == 200) {
      var temp = jsonDecode(popmoviesresponse.body);
      var popmoviejson = temp['results'];

      for (var i = 0; i < popmoviejson.length; i++) {
        popmovielist.add({
          "name": popmoviejson[i]['title'],
          "poster_path": popmoviejson[i]['poster_path'],
          "vote_average": popmoviejson[i]['vote_average'],
          "Date": popmoviejson[i]['release_date'],
          "id": popmoviejson[i]['id'],
        });
      }
    } else {
      print(popmoviesresponse.statusCode);
    }

//////////////////////////////////////////////////////////////////////////////////////////

var onairmoviesresponse = await http.get(Uri.parse(nowplayingmoviesurl));
 if (onairmoviesresponse.statusCode == 200) {
      var temp = jsonDecode(onairmoviesresponse.body);
      var onairmoviejson = temp['results'];

      for (var i = 0; i < onairmoviejson.length; i++) {
        onairmovseries.add({
          "name": onairmoviejson[i]['title'],
          "poster_path": onairmoviejson[i]['poster_path'],
          "vote_average": onairmoviejson[i]['vote_average'],
          "Date": onairmoviejson[i]['release_date'],
          "id": onairmoviejson[i]['id'],
        });
      }
    } else {
      print(onairmoviesresponse.statusCode);
    }

//////////////////////////////////////////////////////////////////////////////////////////

var topmoviesresponse = await http.get(Uri.parse(topratedmoviesurl));
 if (topmoviesresponse.statusCode == 200) {
      var temp = jsonDecode(topmoviesresponse.body);
      var topmoviejson = temp['results'];

      for (var i = 0; i < topmoviejson.length; i++) {
        topmovies.add({
          "name": topmoviejson[i]['title'],
          "poster_path": topmoviejson[i]['poster_path'],
          "vote_average": topmoviejson[i]['vote_average'],
          "Date": topmoviejson[i]['release_date'],
          "id": topmoviejson[i]['id'],
        });
      }
    } else {
      print(topmoviesresponse.statusCode);
    }





  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mpvieFunvtion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        } else { return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Sliderlist(topmovies, 'Top Rated Movies', "movie", 20),
              Sliderlist(popmovielist, 'Popular Tv series', "movie", 20),
              Sliderlist(onairmovseries, 'Currently Streaming', "movie", 20)
            ],
          );}
      },
    );
  }
}
