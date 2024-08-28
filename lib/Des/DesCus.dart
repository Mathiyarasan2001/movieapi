import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapi/Des/DesDescription.dart';
import 'package:movieapi/Description.dart';
import 'package:movieapi/custom.dart';

class DesCustom_Movies extends StatefulWidget {
  final String Apikey;
  final String title;

  DesCustom_Movies({Key? key, required this.Apikey, required this.title})
      : super(key: key);

  @override
  State<DesCustom_Movies> createState() => _DesCustom_MoviesState();
}

class _DesCustom_MoviesState extends State<DesCustom_Movies> {
  List<dynamic> data = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.Apikey));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body)['results'];
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            txt: widget.title,
            size: 24,
            color: Colors.white,
          ),
        ),
        data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: height / 2,
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Desdescription(
                                title: data[index]["title"].toString(),
                                description: data[index]["overview"].toString(),
                                banner:
                                    "https://image.tmdb.org/t/p/w500${data[index]["backdrop_path"].toString()}",
                                poster:
                                    "https://image.tmdb.org/t/p/w500${data[index]["poster_path"].toString()}",
                                releasedate:
                                    "Release Date: ${data[index]["release_date"].toString()}",
                                rating:
                                    "Rating: ${data[index]["vote_average"].toString()}",
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Container(
                            height: height / 2.1,
                            width: width / 5,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/w500${data[index]["poster_path"]}"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class DesCustom_Series extends StatefulWidget {
  final String Apikey;

  DesCustom_Series({
    Key? key,
    required this.Apikey,
  }) : super(key: key);

  @override
  State<DesCustom_Series> createState() => _DesCustom_SeriesState();
}

class _DesCustom_SeriesState extends State<DesCustom_Series> {
  List<dynamic> data = [];
  late ScrollController _scrollController;
  late Timer _timer;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.Apikey));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body)['results'];
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchData().then((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = MediaQuery.sizeOf(context).width / 3;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0); // Reset to start
        } else {
          _scrollController.animateTo(currentScroll + delta,
              duration: Duration(seconds: 2), curve: Curves.easeInOut);
        }
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // Reached the top
      } else {
        // Reached the bottom
        _scrollController.jumpTo(0); // Reset to start
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: height / 2.5,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Desdescription(
                                      title: data[index]["name"].toString(),
                                      description:
                                          data[index]["overview"].toString(),
                                      banner:
                                          "https://image.tmdb.org/t/p/w500${data[index]["backdrop_path"].toString()}",
                                      poster:
                                          "https://image.tmdb.org/t/p/w500${data[index]["poster_path"].toString()}",
                                      releasedate:
                                          "Release Date: ${data[index]["first_air_date"].toString()}",
                                      rating:
                                          "Rating: ${data[index]["vote_average"].toString()}",
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Container(
                                  height: height / 2.5,
                                  width: width / 2.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${data[index]["backdrop_path"]}',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CustomText(
                                      txt: data[index]["name"],
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class DesCustom_PopSeries extends StatefulWidget {
  final String Apikey;
  final String title;

  DesCustom_PopSeries({Key? key, required this.Apikey, required this.title})
      : super(key: key);

  @override
  State<DesCustom_PopSeries> createState() => _DesCustom_PopSeriesState();
}

class _DesCustom_PopSeriesState extends State<DesCustom_PopSeries> {
  List<dynamic> data = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.Apikey));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body)['results'];
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            txt: widget.title,
            size: 24,
            color: Colors.white,
          ),
        ),
        data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
                height: height / 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Desdescription(
                                title: data[index]["name"].toString(),
                                description: data[index]["overview"].toString(),
                                banner:
                                    "https://image.tmdb.org/t/p/w500${data[index]["backdrop_path"].toString()}",
                                poster:
                                    "https://image.tmdb.org/t/p/w500${data[index]["poster_path"].toString()}",
                                releasedate:
                                    "Release Date: ${data[index]["first_air_date"].toString()}",
                                rating:
                                    "Rating: ${data[index]["vote_average"].toString()}",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: height / 2,
                          width: width / 6,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w500${data[index]["poster_path"]}"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
