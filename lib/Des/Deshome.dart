import 'package:flutter/material.dart';
import 'package:movieapi/Des/DesCus.dart';
import 'package:movieapi/Des/Dessearch.dart';
import 'package:movieapi/custom.dart';
import 'package:movieapi/search.dart';

class DesHomePage extends StatefulWidget {
  const DesHomePage({Key? key}) : super(key: key);

  @override
  State<DesHomePage> createState() => _DesHomePageState();
}

class _DesHomePageState extends State<DesHomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900], // Change the color here
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.search, color: Colors.white),
                title: Text('Search', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dessearch()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
        ),
        title: CustomText(txt: "Movie Api", size: 30, color: Colors.red),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dessearch()),
              );
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DesCustom_Series(
              Apikey:
                  "https://api.themoviedb.org/3/tv/top_rated?api_key=2b5b897f647f0968f0d8a11462b09058",
            ),
            SizedBox(
              height: height / 20,
            ),
            DesCustom_Movies(
              Apikey:
                  "https://api.themoviedb.org/3/movie/top_rated?api_key=2b5b897f647f0968f0d8a11462b09058",
              title: "Top Rated Movies",
            ),
            DesCustom_PopSeries(
                Apikey:
                    "https://api.themoviedb.org/3/tv/top_rated?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Top Rated Series"),
            DesCustom_Movies(
                Apikey:
                    "https://api.themoviedb.org/3/movie/popular?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Popular Movies"),
            DesCustom_PopSeries(
                Apikey:
                    "https://api.themoviedb.org/3/tv/popular?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Popular Series"),
            DesCustom_Movies(
                Apikey:
                    "https://api.themoviedb.org/3/movie/upcoming?api_key=2b5b897f647f0968f0d8a11462b09058",
                title: "Upcoming"),
          ],
        ),
      ),
    );
  }
}
