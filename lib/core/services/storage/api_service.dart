import 'package:coffeshop_mobile/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;

Future<http.Response> login(Map<String, dynamic> data) async {
  final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.login}';

  print("LOGIN URL: $url");

  final response = await http.post(
    Uri.parse(url),
    body: data,
  );

  return response;
}
//http://192.168.1.83:3000/

