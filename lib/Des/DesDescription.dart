import 'package:flutter/material.dart';
import 'package:movieapi/custom.dart';

class Desdescription extends StatefulWidget {
  final String title, description, banner, poster, releasedate, rating;
  Desdescription({
    Key? key,
    required this.title,
    required this.description,
    required this.banner,
    required this.poster,
    required this.releasedate,
    required this.rating,
  }) : super(key: key);

  @override
  State<Desdescription> createState() => _DesdescriptionState();
}

class _DesdescriptionState extends State<Desdescription> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: CustomText(txt: widget.title, size: 24, color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 10,
            ),
            Center(
              child: Container(
                  height: height / 2,
                  width: width / 1.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.banner),
                          fit: BoxFit.fill)),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomText(
                          txt: widget.rating, size: 14, color: Colors.white))),
            ),
            SizedBox(
              height: 5,
            ),
            CustomText(txt: widget.title, size: 24, color: Colors.white),
            SizedBox(
              height: 5,
            ),
            CustomText(txt: widget.releasedate, size: 18, color: Colors.white),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: height / 2,
                      width: width / 5,
                      child: Image.network(
                        widget.poster,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                      height: 200,
                      width: width / 3,
                      child: CustomText(
                          txt: widget.description,
                          size: 14,
                          color: Colors.white))
                ],
              ),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
