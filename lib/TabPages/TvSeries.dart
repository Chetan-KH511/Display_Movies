import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/apikey/apiKey.dart';

class Tvseries extends StatefulWidget {
  @override
  State<Tvseries> createState() => _TvseriesState();
}

class _TvseriesState extends State<Tvseries> {
  List<Map<String, dynamic>> popularTvseries = [];

  var popularTvseriesurl =
      'https://api.themoviedb.org/3/tv/popular?api_key=$apikey';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
                  child: Text('Popular Tv series')),
              Container(
                height: 250,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: popularTvseries.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken),
                                  image: NetworkImage(
                                      'http://image.tmdb.org/t/p/w500${popularTvseries[index]['poster_path']}'),
                                )),
                            margin: EdgeInsets.only(left: 13),
                            width: 170,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 2, left: 6),
                                    child:
                                        Text(popularTvseries[index]['Date'])),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, right: 6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, right: 5, left: 6, bottom: 2),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber,),
                                          SizedBox(width: 2),
                                          Text(popularTvseries[index]
                                                  ['vote_average']
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )));
                  },
                ),
              )
            ],
          );
        }
      },
    );
  }
}
