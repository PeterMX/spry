import 'package:webfetch/webfetch.dart';

import '../request/request_event.dart';
import 'dart:async';

import 'responder.dart';

class ClosureResponder implements Responder {
  final FutureOr<Response> Function(RequestEvent event) _closure;

  const ClosureResponder(
      FutureOr<Response> Function(RequestEvent event) closure)
      : _closure = closure;

  @override
  FutureOr<Response> respond(RequestEvent event) => _closure(event);
}
