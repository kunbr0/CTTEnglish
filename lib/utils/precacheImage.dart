import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';

Future<void> precacheImage(
  ImageProvider provider,
  BuildContext context, {
  Size size,
  ImageErrorListener onError,
}) {
  final ImageConfiguration config = createLocalImageConfiguration(context, size: size);
  final Completer<void> completer = Completer<void>();
  final ImageStream stream = provider.resolve(config);
  ImageStreamListener listener;
  listener = ImageStreamListener(
    (ImageInfo image, bool sync) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      // Give callers until at least the end of the frame to subscribe to the
      // image stream.
      // See ImageCache._liveImages
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        stream.removeListener(listener);
      });
    },
    onError: (dynamic exception, StackTrace stackTrace) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      stream.removeListener(listener);
      if (onError != null) {
        onError(exception, stackTrace);
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          context: ErrorDescription('image failed to precache'),
          library: 'image resource service',
          exception: exception,
          stack: stackTrace,
          silent: true,
        ));
      }
    },
  );
  stream.addListener(listener);
  return completer.future;
}