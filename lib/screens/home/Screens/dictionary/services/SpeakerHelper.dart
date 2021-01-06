import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeakerHelper {
  static FlutterTts tts = new FlutterTts();

  static Future speak(String word) async {
    await tts.setSpeechRate(.8);
    await tts.setPitch(1);
    await tts.setLanguage("en-US");

    if ("_newVoiceText" != null) {
      if ("_newVoiceText".isNotEmpty) {
        await tts.awaitSpeakCompletion(true);
        await tts.speak(word);
      }
    }
  }
}
