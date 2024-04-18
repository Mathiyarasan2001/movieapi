import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movieapi/custom.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: CustomText(txt: "Netflix", size: 30, color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Custom_Series(
              Apikey:
                  "https://api.themoviedb.org/3/tv/top_rated?api_key=2b5b897f647f0968f0d8a11462b09058",
            ),
            Custom_Movies(
              Apikey:
                  "https://api.themoviedb.org/3/movie/top_rated?api_key=2b5b897f647f0968f0d8a11462b09058",
              title: "Top Rated Movies",
            ),
            Custom_Movies(
                Apikey:
                    "https://api.themoviedb.org/3/movie/popular?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Popular Movies"),
            Custom_PopSeries(
                Apikey:
                    "https://api.themoviedb.org/3/tv/top_rated?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "TopRated Series"),
            Custom_PopSeries(
                Apikey:
                    "https://api.themoviedb.org/3/tv/popular?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Popular Series"),
            Custom_Movies(
                Apikey:
                    "https://api.themoviedb.org/3/movie/upcoming?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Upcoming"),
          ],
        ),
      ),
    );
  }
}
