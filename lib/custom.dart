import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movieapi/Description.dart';

class CustomText extends StatelessWidget {
  final String txt;
  final Color color;
  final double size;

  CustomText({
    Key? key,
    required this.txt,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: GoogleFonts.bebasNeue(
        textStyle: TextStyle(
            fontSize: size, color: color, decoration: TextDecoration.none),
      ),
    );
  }
}

class Custom_Movies extends StatefulWidget {
  final String Apikey;
  final String title;

  Custom_Movies({Key? key, required this.Apikey, required this.title})
      : super(key: key);

  @override
  State<Custom_Movies> createState() => _Custom_MoviesState();
}

class _Custom_MoviesState extends State<Custom_Movies> {
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
                height: 250,
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
                              builder: (context) => Description(
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
                        child: Container(
                          height: 250,
                          width: 150,
                          color: Colors.black,
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: 150,
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${data[index]["poster_path"]}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
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

class Custom_Series extends StatefulWidget {
  final String Apikey;

  Custom_Series({
    Key? key,
    required this.Apikey,
  }) : super(key: key);

  @override
  State<Custom_Series> createState() => _Custom_SeriesState();
}

class _Custom_SeriesState extends State<Custom_Series> {
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
        double delta = 360;

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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Description(
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
                              child: Container(
                                height: 200,
                                width: 350,
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

// class Custom_Series extends StatefulWidget {
//   final String Apikey;

//   Custom_Series({
//     Key? key,
//     required this.Apikey,
//   }) : super(key: key);

//   @override
//   State<Custom_Series> createState() => _Custom_SeriesState();
// }

// class _Custom_SeriesState extends State<Custom_Series> {
//   List<dynamic> data = [];
//   late ScrollController _scrollcontroller;
//   Future<void> fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(widget.Apikey));

//       if (response.statusCode == 200) {
//         setState(() {
//           data = jsonDecode(response.body)['results'];
//         });
//       } else {
//         throw Exception('Failed to load movies');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _scrollcontroller = ScrollController();
//     fetchData();
//     _autoScroll();
//     fetchData();
//   }

//   void _autoScroll() async {
//     Timer(
//       Duration(seconds: 3),
//       () {
//         if (_scrollcontroller.hasClients) {
//           double maxScroll = _scrollcontroller.position.maxScrollExtent;
//           double currentScroll = _scrollcontroller.position.pixels;
//           double delta = 150;

//           double scrollTo = (currentScroll + delta).clamp(0, maxScroll);
//           _scrollcontroller.animateTo(scrollTo,
//               duration: Duration(seconds: 2), curve: Curves.easeInOut);
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _scrollcontroller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 15,
//           ),
//           data.isEmpty
//               ? Center(child: CircularProgressIndicator())
//               : SizedBox(
//                   height: 200,
//                   child: ListView.builder(
//                     controller: _scrollcontroller,
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: data.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(left: 5, right: 5),
//                         child: Column(
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Description(
//                                       title: data[index]["name"].toString(),
//                                       description:
//                                           data[index]["overview"].toString(),
//                                       banner:
//                                           "https://image.tmdb.org/t/p/w500${data[index]["backdrop_path"].toString()}",
//                                       poster:
//                                           "https://image.tmdb.org/t/p/w500${data[index]["poster_path"].toString()}",
//                                       releasedate:
//                                           "Release Date: ${data[index]["first_air_date"].toString()}",
//                                       rating:
//                                           "Rating: ${data[index]["vote_average"].toString()}",
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                   height: 200,
//                                   width: 350,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                               'https://image.tmdb.org/t/p/w500${data[index]["backdrop_path"]}'),
//                                           fit: BoxFit.fill)),
//                                   child: Align(
//                                     alignment: Alignment.bottomCenter,
//                                     child: CustomText(
//                                       txt: data[index]["name"],
//                                       size: 22,
//                                       color: Colors.white,
//                                     ),
//                                   )),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

class Custom_PopSeries extends StatefulWidget {
  final String Apikey;
  final String title;

  Custom_PopSeries({Key? key, required this.Apikey, required this.title})
      : super(key: key);

  @override
  State<Custom_PopSeries> createState() => _Custom_PopSeriesState();
}

class _Custom_PopSeriesState extends State<Custom_PopSeries> {
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
                height: 250,
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
                              builder: (context) => Description(
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
                          height: 250,
                          width: 150,
                          color: Colors.black,
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: 150,
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${data[index]["poster_path"]}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
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
