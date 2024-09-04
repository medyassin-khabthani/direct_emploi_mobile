
import '../datas/de_datas.dart';
import 'package:html/parser.dart';

String buildTitleString(String query, String localisation, String selectedContrat) {
  String queryPart = query.isNotEmpty ? "$query - " : "Tous les métiers - ";
  String localisationPart = localisation.isNotEmpty ? "$localisation - " : "Partout - ";
  String contratPart = selectedContrat.isNotEmpty ? contratOptions[selectedContrat] ?? "Tous les contrats" : "Tous les contrats";

  return "$queryPart$localisationPart$contratPart";
}
String? parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String? parsedString = parse(document.body?.text).documentElement?.text;

  return parsedString;
}

String limitToLines(String text, int maxLines, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }

  int endIndex = maxLength;
  for (int i = 0; i < maxLines; i++) {
    int newIndex = text.indexOf('\n', endIndex);
    if (newIndex == -1 || newIndex >= maxLength) {
      break;
    }
    endIndex = newIndex + 1;
  }

  if (endIndex < text.length) {
    return '${text.substring(0, endIndex).trim()}...';
  } else {
    return text;
  }
}