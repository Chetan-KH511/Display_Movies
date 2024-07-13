
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

import 'package:movie_app/apilinks/apiLinks.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> trendinglistHome() async {
    var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));

    if (trendingweekresponse.statusCode == 200) {
      var tempdata = jsonDecode(trendingweekresponse.body);
      var trendingweekjson = tempdata['results'];          //the data from tmdb gives json, where all data is under results
      for (var i = 0; i < trendingweekjson.length; i++) {
        trendinglist.add({
          'id': trendingweekjson[i]['id'],
          'poster_path': trendingweekjson[i]['poster_path'],
          'vote_average': trendingweekjson[i]['vote_average'],
          'media_type': trendingweekjson[i]['media_type'],
          'indexno': i,
        });
      }
    }

//For daily trending categories
    var trendingdayresponse = await http.get(Uri.parse(trendingdayurl));

    if (trendingdayresponse.statusCode == 200) {
      var tempdata = jsonDecode(trendingweekresponse.body);
      var trendingdayjson = tempdata['results'];        //the data from tmdb gives json, where all data is under results
      for (var i = 0; i < trendingdayjson.length; i++) {
        trendinglist.add({
          'id': trendingdayjson[i]['id'],
          'poster_path': trendingdayjson[i]['poster_path'],
          'vote_average': trendingdayjson[i]['vote_average'],
          'media_type': trendingdayjson[i]['media_type'],
          'indexno': i,
        });
      }
    }
  }

  int uval = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                  future: trendinglistHome(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.done) {
                      return CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 2),
                            height: MediaQuery.of(context).size.height),
                        items: trendinglist.map(
                          (e) {
                            return Builder(builder: (BuildContext context) {
                              return GestureDetector(
                                  onTap: () {},
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.3),
                                                    BlendMode.darken),
                                                image: NetworkImage(
                                                  'http://image.tmdb.org/t/p/w500${e['poster_path']}'),
                                                fit: BoxFit.fill)),
                                      )));
                            });
                          }).toList(),
                      );

                    } else {

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  }),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Trending' + '🔥',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 16)),
                SizedBox(width: 10),
                Container()
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: Text('Sample Text'),
            ),
          ]))
        ],
      ),
    );
  }
}
