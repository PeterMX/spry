part of '../spry.dart';

/// [Spry] implementation.
class _SpryImpl implements Spry {
  Middleware? middleware;

  @override
  void use(Middleware middleware) {
    this.middleware = this.middleware?.use(middleware) ?? middleware;
  }

  @override
  void Function(HttpRequest request) call(Handler handler) {
    return (HttpRequest request) async {
      final Context context = ContextImpl.fromHttpRequest(request);
      final Middleware middleware = this.middleware ?? emptyMiddleware;

      // Create a middleware next function.
      FutureOr<void> next() => handler(context);

      /// Call middleware.
      await middleware(context, next);

      // Write and close response.
      return writeResponse(context, request.response);
    };
  }

  /// Write response.
  Future<void> writeResponse(Context context, HttpResponse response) async {
    final Response spryResponse = context.response;

    // Write status code.
    response.statusCode = spryResponse.statusCode;

    // Write cookies.
    for (final Cookie cookie in spryResponse.cookies) {
      response.cookies.add(cookie);
    }

    // Write body.
    if (spryResponse.body != null) {
      await response.addStream(spryResponse.body!);
    }

    // Close response.
    await response.close();
  }

  /// Default empty middleware.
  static FutureOr<void> emptyMiddleware(Context context, MiddlewareNext next) =>
      next();
}
