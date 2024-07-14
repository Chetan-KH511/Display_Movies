import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app/RepeatedFuncs/slider.dart';
import 'package:movie_app/apikey/apiKey.dart';

class Trailerui extends StatefulWidget {
   Trailerui({this.trailerid ,super.key});

  var trailerid;

  @override
  _TraileruiState createState() => _TraileruiState();
}

class _TraileruiState extends State<Trailerui> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}