//import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../models/SearchDataModel.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

class EventDetailScreen extends StatelessWidget {
 // EventDetailScreen(Set set);
  final Event item;
  const EventDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            item.title,
          style: TextStyle(fontSize: 18),
        ),
        flexibleSpace: Container(
          decoration:  const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF79CBCA), Color(0xFF77A1D3)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Container(
            child: Text(
              item.title,
            ),
          ),*/
          const SizedBox(
            height: 15.0,
          ),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            shadowColor: Color(0xFF79CBCA),
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: CachedNetworkImage(
                imageUrl: item.performers[0].image ?? "null",
                fit: BoxFit.fitWidth,
                width: double.infinity,
                
               // height: 500,
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            padding:const EdgeInsets.only(left: 25.0) ,
            child: Text(
              formatedDateTime(item.datetime),
              style: const TextStyle(
                fontSize: 20,
                //color: Color(0XFFcc3e12),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            padding:const EdgeInsets.only(left: 25.0) ,
            child: Text(
              item.venue.display_location,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ]
      )
    );
  }
  
  
}