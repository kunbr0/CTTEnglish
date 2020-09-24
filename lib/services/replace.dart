String replaceList(String string, List<String> from, String to) {
  String replacedString = string;
  for (String specialChar in from) {
    replacedString = replacedString.replaceAll(".", "");
  }

  return replacedString;
}
