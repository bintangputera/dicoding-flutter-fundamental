import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/constant/app_constant.dart';

class NetworkService {
  Future<dynamic> getMethod(String endpoint) async {
    try {
      print("requested endpoint : $endpoint");
      final getResponse = await http.get(Uri.parse("$BASE_URL/$endpoint"));
      var res = json.decode(getResponse.body);

      if (res['error'] == false) {
        return res;
      } else {
        return Exception(res['message']);
      }
    } on SocketException {
      throw Exception("Connection failed");
    }
  }

  Future<dynamic> postMethod(String endpoint, Map<String, dynamic> body) async {
    try {
      print("requested endpoint : $endpoint");
      final postResponse =
          await http.post(Uri.parse("$BASE_URL/$endpoint"), body: body);
      var res = json.decode(postResponse.body);

      if (res['error'] == false) {
        return res;
      } else {
        return Exception(res['message']);
      }
    } on SocketException {
      throw Exception("Connection failed");
    }
  }
}
