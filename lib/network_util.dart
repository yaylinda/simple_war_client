import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();
  final JsonEncoder _encoder = new JsonEncoder();
  final Map<String, String> _defaultHeaders = {"Content-Type" : "application/json"};

  Future<dynamic> get(String url) {
    print("Making GET request to " + url);

    return http
        .get(url)
        .then((http.Response response) {

      final String res = response.body;
      final int statusCode = response.statusCode;

      print("Result... statusCode=$statusCode, body=$res");

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("$res");
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, Map body) {
    print("Making POST request to " + url);
    print("...with body: " + body.toString());

    return http
        .post(url, body: _encoder.convert(body), headers: _defaultHeaders)
        .then((http.Response response) {

      final String res = response.body;
      final int statusCode = response.statusCode;

      print("Result... statusCode=$statusCode, body=$res");

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("$res");
      }

      return _decoder.convert(res);
    });
  }
}
