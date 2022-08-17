
import 'package:search_app/models/performer_model.dart';
import 'package:search_app/models/venue_model.dart';

class Event {
  final String title;
  final String datetime;
  List<Performers> performers;
  Venue venue;

  Event(
      {required this.title,
        required this.datetime,
        required this.performers,
        required this.venue,
       });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        title: json["title"],
        datetime: json["datetime_utc"],

        performers: List<Performers>.from(
          json["performers"].map((x) => Performers.fromJson(x))),

        venue: Venue.fromJson(json["venue"]),

       );
  }

}

