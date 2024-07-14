import 'package:flutter/material.dart';
import 'package:movie_app/Details/moviesdetail.dart';
import 'package:movie_app/Details/tvseries.dart';

class checkUi extends StatefulWidget {
  var newId;
  var newType;

  checkUi({this.newId, this.newType});

  @override
  State<StatefulWidget> createState() => _checkuiState();
}

class _checkuiState extends State<checkUi> {
  // checkType() {
  //   if (widget.newType == 'movie') {
  //     return moviesDetail(
  //       movieId: widget.newId,
  //     );
  //   } else if (widget.newType == 'tv') {
  //     return tvdetail(
  //       movieId: widget.newId,
  //     );
  //   } else {
  //     return errorui();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Widget errorui() {
  return Scaffold(
    body: Center(
      child: Text('Error'),
    ),
  );
}
