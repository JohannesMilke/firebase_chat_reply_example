@JS()
library filter;

import 'dart:async';

import 'package:js/js.dart';
import 'package:node_interop/node.dart';
import 'package:node_interop/util.dart';

@JS()
@anonymous
abstract class Filter {
  external void getCleanedMessage(String message, doneCallback);
}

Future<String> getCleanedMessage(String message) {
  final filter = require('./filter.js');

  final completer = Completer();
  final doneCallback = allowInterop((result) => completer.complete(result));
  filter.getCleanedMessage(message, doneCallback);

  return completer.future.then(dartify);
}
