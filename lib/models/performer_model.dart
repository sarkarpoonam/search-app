import 'dart:collection';

class Performers {
  String? image = "";

static Performers fromJson(LinkedHashMap<String, dynamic>json) {
    var performer = Performers();
    if(json.containsKey("image")) {
        performer.image = json["image"];
        print(performer.image);
    }
      return performer;
  }
}