import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/apikey/apii.dart';
class Upcomming extends StatefulWidget{
  @override
  State<Upcomming> createState() => _upcommingState();
  
}

class _upcommingState extends State<Upcomming>{
  List<Map<String, dynamic>> upcomingSerieslist = [];
  

  var upcomingurl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey';

  Future<void> upcommingFunction() async {
    var upcommingresponse = await http.get(Uri.parse(upcomingurl));

    if (upcommingresponse.statusCode == 200) {
      var temp = jsonDecode(upcommingresponse.body);
      var upcomingjson = temp['results'];

      for (var i = 0; i < upcomingjson.length; i++) {
        upcomingSerieslist.add({
          "name": upcomingjson[i]['name'],
          "poster_path": upcomingjson[i]['poster_path'],
          "vote_average": upcomingjson[i]['vote_average'],
          "Date": upcomingjson[i]['release_date'],
          "id": upcomingjson[i]['id'],
        });
      }
    } else {
      print(upcommingresponse.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: upcommingFunction(),
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
                  child: Text('Upcoming series')),
              Container(
                height: 250,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: upcomingSerieslist.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => moviedetailScreen(),))



                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken),
                                  image: NetworkImage(
                                      'http://image.tmdb.org/t/p/w500${upcomingSerieslist[index]['poster_path']}'),
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
                                        Text(upcomingSerieslist[index]['Date'])),
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
                                          Text(upcomingSerieslist[index]
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