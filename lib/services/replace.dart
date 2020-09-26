String replaceList(String string, List<String> from, String to) {
  String replacedString = string;
  for (String specialChar in from) {
    print(specialChar);
    replacedString = replacedString.replaceAll(specialChar, "");
  }

  return replacedString;
}
