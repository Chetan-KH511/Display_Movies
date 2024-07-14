import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/Homepage/HomePage.dart';
import 'package:movie_app/RepeatedFuncs/slider.dart';
import 'package:movie_app/apikey/apiKey.dart';

class moviesDetail extends StatefulWidget {
  var id;
  moviesDetail({required this.id});

  @override
  State<StatefulWidget> createState() => moviestate();
}

class moviestate extends State<moviesDetail> {
  List<Map<String, dynamic>> movieDetails = [];
  List<Map<String, dynamic>> UserReviews = [];
  List<Map<String, dynamic>> similarMovies = [];
  List<Map<String, dynamic>> recommendedmovies = [];
  List<Map<String, dynamic>> movietrailer = [];

  List<Map<String, dynamic>> Moviegenres = [];

  Future<void> MoviesDetails() async {
    var moviedetailurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '?api_key=$apikey';

    var userreview = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/reviews?api_key=$apikey';

    var similarmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';

    var recommended = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';

    var movietrailerurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/videos?api_key=$apikey';

    var moviedetresponse = await http.get(Uri.parse(moviedetailurl));

    if (moviedetresponse.statusCode == 200) {
      var mdetjson = jsonDecode(moviedetresponse.body);
      for (var i = 0; i < 1; i++) {
        movieDetails.add({
          "backdrop_path": mdetjson['backdrop_path'],
          "title": mdetjson['title'],
          "vote_average": mdetjson['vote_average'],
          "overview": mdetjson['overview'],
          "release_date": mdetjson['release_date'],
          "runtime": mdetjson['runtime'],
          "budget": mdetjson['budget'],
          "revenue": mdetjson['revenue'],
        });
      }
      for (var i = 0; i < mdetjson['genres'].length; i++) {
        Moviegenres.add(mdetjson['genres'][i]['name']);
      }
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    var UserReviewresponse = await http.get(Uri.parse(userreview));
    if (UserReviewresponse.statusCode == 200) {
      var UserReviewjson = jsonDecode(UserReviewresponse.body);
      for (var i = 0; i < UserReviewjson['results'].length; i++) {
        UserReviews.add({
          "name": UserReviewjson['results'][i]['author'],
          "review": UserReviewjson['results'][i]['content'],
          //check rating is null or not
          "rating":
              UserReviewjson['results'][i]['author_details']['rating'] == null
                  ? "Not Rated"
                  : UserReviewjson['results'][i]['author_details']['rating']
                      .toString(),
          "avatarphoto": UserReviewjson['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  UserReviewjson['results'][i]['author_details']['avatar_path'],
          "creationdate":
              UserReviewjson['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": UserReviewjson['results'][i]['url'],
        });
      }
    } else {}
    /////////////////////////////similar movies
    var similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
    if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarMovies.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    } else {}
    /////////////////////////////recommended movies
    var recommendedmoviesresponse = await http.get(Uri.parse(recommended));
    if (recommendedmoviesresponse.statusCode == 200) {
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        recommendedmovies.add({
          "poster_path": recommendedmoviesjson['results'][i]['poster_path'],
          "name": recommendedmoviesjson['results'][i]['title'],
          "vote_average": recommendedmoviesjson['results'][i]['vote_average'],
          "Date": recommendedmoviesjson['results'][i]['release_date'],
          "id": recommendedmoviesjson['results'][i]['id'],
        });
      }
    } else {}
    /////////////////////////////movie trailers
    var movietrailersresponse = await http.get(Uri.parse(movietrailerurl));
    if (movietrailersresponse.statusCode == 200) {
      var movietrailersjson = jsonDecode(movietrailersresponse.body);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        if (movietrailersjson['results'][i]['type'] == "Trailer") {
          movietrailer.add({
            "key": movietrailersjson['results'][i]['key'],
          });
        }
      }
      movietrailer.add({'key': 'aJ0cZTcTh90'});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
          future: MoviesDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(FontAwesomeIcons.circleArrowLeft),
                            iconSize: 28,
                            color: Colors.white),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              },
                              icon: Icon(FontAwesomeIcons.houseUser),
                              iconSize: 25,
                              color: Colors.white)
                        ],
                        backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                        centerTitle: false,
                        pinned: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.4,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: FittedBox(
                            fit: BoxFit.fill,
                            child: trailerwatch(
                              trailerytid: movietrailer[0]['key'],
                            ),
                          ),
                        )),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Column(
                        children: [
                          Row(children: [
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Moviegenres.length,
                                    itemBuilder: (context, index) {
                                      //generes box
                                      return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(25, 25, 25, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child:
                                              Text(Moviegenres[index] as String));
                                    })),
                          ]),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                      movieDetails[0]['runtime'].toString() +
                                          ' min'))
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text('Movie Story :')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                              movieDetails[0]['overview'].toString())),

                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: ReviewUI(revdeatils: UserReviews),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Release Date : ' +
                              movieDetails[0]['release_date'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Budget : ' +
                              movieDetails[0]['budget'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Revenue : ' +
                              movieDetails[0]['revenue'].toString())),
                      Sliderlist(similarMovies, "Similar Movies", "movie",
                          similarMovies.length),
                      Sliderlist(recommendedmovies, "Recommended Movies",
                          "movie", recommendedmovies.length),
                      // Container(
                      //     height: 50,
                      //     child: Center(child: normaltext("By Niranjan Dahal")))
                    ]))
                  ]);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            }
          }),
    );
  }
}
