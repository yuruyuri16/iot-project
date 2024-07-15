import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sns_client/sns_client.dart';
import 'package:sns_client/src/io.dart'
    if (dart.library.html) 'package:sns_client/src/browser.dart' as d;

/// {@template flutter_news_example_api_malformed_response}
/// An exception thrown when there is a problem decoding the response body.
/// {@endtemplate}
class SnsClientApiMalformedResponse implements Exception {
  /// {@macro flutter_news_example_api_malformed_response}
  const SnsClientApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// {@template sns_client_request_failure}
/// An exception thrown when an http request failure occurs.
/// {@endtemplate}
class SnsClientRequestFailure implements Exception {
  /// {@macro flutter_news_example_api_request_failure}
  const SnsClientRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final List<dynamic> body;
}

/// {@template sns_client}
/// A client for interacting with the SNS API.
/// {@endtemplate}
class SnsClient {
  /// {@macro sns_client}
  SnsClient() : _httpClient = d.setup();

  final http.Client _httpClient;

  ///
  Future<List<Climate>> getSensorData() async {
    final uri = Uri.http('localhost:8080', '/api/sensor_data');
    final response = await _httpClient.get(uri);
    final body = response.jsonList();

    if (response.statusCode != HttpStatus.ok) {
      Error.throwWithStackTrace(
        SnsClientRequestFailure(statusCode: response.statusCode, body: body),
        StackTrace.current,
      );
    }
    final res = body
        .map((json) => Climate.fromJson(json as Map<String, dynamic>))
        .toList();
    return res;
  }
}

extension on http.Response {
  List<dynamic> jsonList() {
    try {
      final decodedBody = utf8.decode(bodyBytes);
      return jsonDecode(decodedBody) as List<dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SnsClientApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
