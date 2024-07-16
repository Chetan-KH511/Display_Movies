import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/Details/checker.dart';
import 'package:movie_app/apikey/apii.dart';
class searchbar extends StatefulWidget {
  const searchbar({super.key});

  @override
  State<searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<searchbar> {
  List<Map<String, dynamic>> searchREsult = [];
  final TextEditingController search = TextEditingController();
  bool show = false;
  var val1;

  Future<void> searchFunction(String val) async {
    var searchurl =
        'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$val';

    var searchresp = await http.get(Uri.parse(searchurl));

    if (searchresp.statusCode == 200) {
      var temp = jsonDecode(searchresp.body);
      var searchjson = temp['results'];

      for (var item in searchjson) {
        if (item['id'] != null &&
            item['poster_path'] != null &&
            item['vote_average'] != null &&
            item['media_type'] != null) {
          searchREsult.add({
            'name':item['name'],
            'id': item['id'],
            'poster_path': item['poster_path'],
            'vote_average': item['vote_average'],
            'media_type': item['media_type'],
            'popularity': item['popularity'],
            'overview': item['overview'],
          });

          if (searchREsult.length > 20) {
            searchREsult.removeRange(20, searchREsult.length);
          }
        } else {
          print('Null val');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        show != show;
      },
      child: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 30, bottom: 20, right: 10),
          child: Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: TextField(
                  autofocus: false,
                  controller: search,
                  onSubmitted: (value) {
                    searchREsult.clear();
                    setState(() {
                      val1 = value;
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  onChanged: (value) {
                    searchREsult.clear();

                    setState(() {
                      val1 = value;
                    });
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              webBgColor: "#000000",
                              webPosition: "center",
                              webShowClose: true,
                              msg: "Search Cleared",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            search.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.amber.withOpacity(0.6),
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.amber,
                      ),
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.2)),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              search.text.length! > 0
                  ? FutureBuilder(
                      future: searchFunction(val1),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                              height: 400,
                              child: ListView.builder(
                                  itemCount: searchREsult.length,
                                  scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => checkUi(
                                                        newId:
                                                            searchREsult[index]
                                                                ['id'],
                                                        newType:
                                                            searchREsult[index]
                                                                ['media_type'],
                                                      )));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            height: 180,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    20, 20, 20, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Row(children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                        //color filter

                                                        image: NetworkImage(
                                                            'https://image.tmdb.org/t/p/w500${searchREsult[index]['poster_path']}'),
                                                        fit: BoxFit.fill)),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                        Column(
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .topCenter,
                                                              child: Text(
                                                                '${searchREsult[index]['name']}',
                                                                style: TextStyle(fontSize: 15, color: Colors.yellow),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .topCenter,
                                                              child: Text(
                                                                '${searchREsult[index]['media_type']}',
                                                              ),
                                                            ),

                                                          ],
                                                        ),

                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              //vote average box
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                height: 30,
                                                                // width:
                                                                //     100,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .amber
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        const BorderRadius.all(
                                                                            Radius.circular(6))),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          '${searchREsult[index]['vote_average']}')
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),

                                                              //popularity
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .amber
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(8))),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .people_outline_sharp,
                                                                        color: Colors
                                                                            .amber,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          '${searchREsult[index]['popularity']}')
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                              //
                                                            ],
                                                          ),
                                                        ),

                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            height: 85,
                                                            child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                ' ${searchREsult[index]['overview']}',
                                                                // 'dsfsafsdffdsfsdf sdfsadfsdf sadfsafd',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white)))
                                                      ])))
                                            ])));
                                  }));
                        } else {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.amber,
                          ));
                        }
                      })
                  : Container(),
            ],
          )),
    );
  }
}
