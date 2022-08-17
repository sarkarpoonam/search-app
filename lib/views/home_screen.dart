//declare packages
import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:search_app/models/performer_model.dart';
import '../models/SearchDataModel.dart';
import 'package:date_format/date_format.dart';
import 'event_detail_screen.dart';
import '../utils.dart';


class SearchApp extends StatefulWidget {
  SearchApp() : super();

  @override
  SearchAppState createState() => SearchAppState();

}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class SearchAppState extends State<SearchApp> {
  final _debouncer = Debouncer();
  List<Event> _events = <Event>[];
  List<Event> userevents = <Event>[];
  bool updatingWishList = false;
  TextEditingController _controller = TextEditingController();
  //API call for All events List

  String url = 'https://api.seatgeek.com/2/events?client_id=Mjg0ODc4NzN8MTY2MDY3MDM1OC41MjcyNjY1&q=Texas+Ranger';

  Future<List<Event>> _fetchAllEvents() async {
    final response = await http.get(
        Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["events"];
      return list.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchAllEvents().then((subjectFromServer) {
      setState(() {
        _events = subjectFromServer;
        userevents = _events;
        print("start");
        print(userevents.length);
        print(userevents[0].performers.length);
        print(userevents[0].venue.display_location);
       });
    });
  }


  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(fontSize: 25),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
      body: Container(
          child: Column(
          children: <Widget>[
            //Search Bar to List of typed Subject
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color:  Color(0xFF79CBCA),
                    ),
                  ),
                  prefixIcon: const InkWell(
                    child: Icon(
                        Icons.search,
                        color:  Color(0xFF79CBCA),
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: (){
                      setState(() {
                        _controller.clear();
                        userevents = _events;
                      });
                    } ,
                    child: const Icon(
                      Icons.clear,
                      color:  Color(0xFF79CBCA),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  hintText: 'Search ',
                ),
                onChanged: (string) {
                  _debouncer.run(() {
                    setState(() {
                     userevents = _events
                          .where(
                            (u) => (u.title.toLowerCase().contains(
                          string.toLowerCase(),
                        )),
                      ).toList();
                    });
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(5),
                itemCount: userevents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventDetailScreen(item:userevents[index])),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),//EdgeInsets.only(left: 18.0, top: 10.0, bottom: 10.0, right:18.0),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFB9FFFF), Color(0xFF77A1D3)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius:BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: userevents[index].performers[0].image ?? "null",
                                fit: BoxFit.fill,
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    userevents[index].title,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    userevents[index].venue.display_location,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black38,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    formatedDateTime(userevents[index].datetime),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0XFFcc3e12),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),


                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                updatingWishList = true;
                              });

                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 3, right: 3),
                              padding: const EdgeInsets.all(6),
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1.0,
                                    ),
                                  ]),
                              child: getFavPicture(),
                            ),
                          )
                      )
                    ],

                  );
                },
              ),
            ),
          ],
        ),

      ),
    );
  }
  Widget getFavPicture() {
   // return SvgPicture.asset("assets/shoppingList_image.svg");
    if(updatingWishList){
      return SvgPicture.asset("assets/likedButton_image.svg");
    }else{
      return SvgPicture.asset( "assets/shoppingList_image.svg");
    }

  }
}

