import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/TabPages/Movies.dart';
import 'package:movie_app/TabPages/TvSeries.dart';
import 'package:movie_app/TabPages/upcomming.dart';
import 'dart:convert';
import 'package:movie_app/apilinks/apiLinks.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //for tabController using tickerproviider
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> trendinglistHome() async {
    if (uval == 1) {
      var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));

      if (trendingweekresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingweekresponse.body);
        var trendingweekjson = tempdata[
            'results']; //the data from tmdb gives json, where all data is under results
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
    } else if (uval == 2) {
      var trendingdayresponse = await http.get(Uri.parse(trendingdayurl));

      if (trendingdayresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingdayresponse.body);
        var trendingdayjson = tempdata[
            'results']; //the data from tmdb gives json, where all data is under results
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
    } else {}
  }

//For daily trending categories

  int uval = 1;
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

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
                        items: trendinglist.map((e) {
                          return Builder(builder: (BuildContext context) {
                            return GestureDetector(
                                onTap: () {},
                                child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
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
                          color: Color.fromARGB(255, 225, 244, 54),
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
                Container(
                  height: 45,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: DropdownButton(
                      onChanged: (value) {
                        setState(() {
                          trendinglist.clear();
                          uval = int.parse(value.toString());
                        });
                      },
                      autofocus: true,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      dropdownColor: Colors.black.withOpacity(0.6),
                      icon: const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color.fromARGB(255, 255, 233, 34),
                      ),
                      value: uval, //acts as starting point
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            'Weekly',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(
                            'Daily',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const Center(
              child: Text('Sample Text'),
            ),
            Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                    physics: const BouncingScrollPhysics(),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.amber.withOpacity(0.4),
                    ),
                    tabs: const [
                      Tab(child: Text('Tv Series')),
                      Tab(child: Text('Movies')),
                      Tab(child: Text('Upcoming')),
                    ])),
            Container(
              height: 1050,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Tvseries(),
                  Movies(),
                  Upcomming(),
                ],
              ),
            )
          ]))
        ],
      ),
    );
  }
}
