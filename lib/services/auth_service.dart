import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

final storage = FlutterSecureStorage();

Future<bool> login(String email, String password) async {
  final res = await http.post(
    Uri.parse('http://your-api/login'),
    body: jsonEncode({'email': email, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode == 200) {
    final token = jsonDecode(res.body)['token'];
    await storage.write(key: 'jwt', value: token);
    return true;
  }
  return false;
}

Future<String?> getToken() async {
  return await storage.read(key: 'jwt');
}
