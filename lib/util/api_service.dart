import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map> api(String endpoint) async {
  var url = "http://192.168.1.4/api/crud/$endpoint";
  // var url = "https://demo.lazday.com/api/crud/$endpoint";
  var response = await http.get(url);
  return json.decode(response.body);
}