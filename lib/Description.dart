import 'package:flutter/material.dart';
import 'package:movieapi/custom.dart';

class Description extends StatefulWidget {

  final String title,description,banner,poster,releasedate,rating;
   Description({
     Key? key,
     required this.title,
     required this.description,
     required this.banner,
     required this.poster,
     required this.releasedate,
     required this.rating,
   }) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        title: CustomText(txt: widget.title, size: 24, color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(widget.banner),fit: BoxFit.cover)
              ),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: CustomText(txt: widget.rating, size: 14, color: Colors.white))),
SizedBox(height: 5,),
CustomText(txt: widget.title, size: 24, color: Colors.white),
          SizedBox(height: 5,),
CustomText(txt: widget.releasedate, size: 18, color: Colors.white),
          SizedBox(height: 5,),
          SizedBox(
            height: 200,
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(
                height: 200,
                width: 100,
                child: Image.network(widget.poster,fit: BoxFit.fill,)),
                SizedBox(
                    height: 200,
                    width: 220,
                    child: CustomText(txt: widget.description, size: 14, color: Colors.white))
            ],),
          )



        ],
      ),
    );
  }
}
