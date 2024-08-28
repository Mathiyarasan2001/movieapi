import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movieapi/Des/DesDescription.dart';
import 'package:movieapi/custom.dart';

class Dessearch extends StatefulWidget {
  const Dessearch({super.key});

  @override
  State<Dessearch> createState() => _DessearchState();
}

class _DessearchState extends State<Dessearch> {
  List<dynamic> data = [];

  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchData(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/search/movie?api_key=2b5b897f647f0968f0d8a11462b09058&query=$query'),
      );

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

  void _onSearchChanged() {
    fetchData(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomText(txt: "search", size: 30, color: Colors.red),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  labelText: 'Search Movies',
                  labelStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _onSearchChanged(),
              ),
            ),
            Expanded(
                child: data.isEmpty
                    ? Center(
                        child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      ))
                    : SizedBox(
                        height: height / 1,
                        width: width / 1.7,
                        child: GridView.builder(
                          itemCount: data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: .1 / .2,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Desdescription(
                                      title: data[index]["title"].toString(),
                                      description:
                                          data[index]["overview"].toString(),
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
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  height: height / 4,
                                  width: width / 5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://image.tmdb.org/t/p/w500${data[index]["poster_path"]}"),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            );
                          },
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
