import 'dart:collection';

class Venue {
  Venue(
      {required this.display_location,

      });
   final String display_location;

  factory Venue.fromJson(Map<String, dynamic>? json) => Venue(
    display_location: json!["display_location"],
  );

}

