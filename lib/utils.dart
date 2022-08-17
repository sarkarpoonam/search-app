import 'package:intl/intl.dart';


String formatedDateTime(timeDate) {
  final f = DateFormat('EEE, d MMMM y HH:mm a');
  DateTime dateTime = DateTime.parse(timeDate);
  if (dateTime != null) {
    return f.format(dateTime);
  }
  return "";
}
