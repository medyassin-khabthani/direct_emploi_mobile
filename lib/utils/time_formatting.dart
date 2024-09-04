
import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('dd MMMM yyyy');
  return formatter.format(dateTime);
}

String formatLocationDate(String region, String city, String dateSoumission) {
  String formattedDate = formatDate(dateSoumission);

  if (region.isEmpty && city.isEmpty) {
    return formattedDate;
  } else if (region.isEmpty) {
    return "$city - $formattedDate";
  } else if (city.isEmpty) {
    return "$region - $formattedDate";
  } else {
    return "$region - $city - $formattedDate";
  }
}
String formatDateString(String dateString) {
  // Parse the date string to a DateTime object
  DateTime dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(dateString, false).toLocal();

  DateTime now = DateTime.now();

  // Calculate the difference
  Duration difference = now.difference(dateTime);

  if (difference.inMinutes < 2) {
    return 'Il y a quelques instants';
  } else if (difference.inMinutes < 60) {
    return 'Il y a ${difference.inMinutes} minutes';
  } else if (difference.inHours < 6) {
    // Plural handling for "heure/heures"
    String hourUnit = difference.inHours > 1 ? 'heures' : 'heure';
    return 'Il y a ${difference.inHours} $hourUnit';
  } else {
    // Custom format for dates older than 6 hours
    return DateFormat("EEE d MMM HH:mm", "fr_FR").format(dateTime);
  }
}
