import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:spry/spry.dart';

import '../constant.dart';

/// Spry [Request]/[Response] JSON middleware.
///
/// Example:
/// ```dart
/// import 'package:spry/spry.dart';
/// import 'package:spry_json/spry_json.dart';
///
/// void main() {
///   // ...
///   spry.use(SpryJson());
///   // ...
/// }
/// ```
class SpryJson extends JsonCodec {
  /// json content type.
  ///
  /// Default: [ContentType.json]
  final ContentType? contentType;

  /// String [Encoding].
  ///
  /// Default: [utf8]
  ///
  /// The [Encoding] used to decode the [request] body.
  ///
  /// If [Response] is not set [encoding], the [encoding] will be used.
  final Encoding? encoding;

  /// Create a [SpryJson] middleware.
  ///
  /// [reviver] @see [JsonCodec]
  /// [toEncodable] @see [JsonCodec]
  ///
  /// [validateRequestHeader] Validate the [Request] content type.
  const SpryJson({
    Object? Function(Object? key, Object? value)? reviver,
    Object? Function(dynamic object)? toEncodable,
    this.contentType,
    this.encoding,
  }) : super(reviver: reviver, toEncodable: toEncodable);

  /// Disguised as [Middleware]
  FutureOr<void> call(Context context, Next next) {
    context.set(SPRY_JSON, this);

    return next();
  }

  /// Get the [SpryJson] instance from the [Context].
  ///
  /// ```dart
  /// final SpryJson json = SpryJson.of(context);
  /// ```
  static SpryJson of(Context context) {
    if (context.contains(SPRY_JSON)) {
      return context.get(SPRY_JSON) as SpryJson;
    }

    _defaultInstance ??= SpryJson();
    context.set(SPRY_JSON, _defaultInstance!);

    return _defaultInstance!;
  }

  /// Default [SpryJson] instance.
  static SpryJson? _defaultInstance;
}
