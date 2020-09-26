String removeSpecialCharater(String string, List<String> from, String to) {
  String replacedString = string;
  for (String specialChar in from) {
    replacedString = replacedString.replaceAll(specialChar, "");
  }

  return replacedString;
}
