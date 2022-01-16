import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import 'function_helpers.dart';

class CreateAccount {
  final HelperFunctions _helpers = HelperFunctions();

  Future<Response> createAccount(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> loginInfo = json.decode(jsonString);
      String? email = loginInfo['email'].toString();
      String? password = loginInfo['password'].toString();

      String endpoint =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" +
              _helpers.getAPI();

      http.Response response = await http.post(Uri.parse(endpoint),
          headers: {'Content-type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('error')) {
        Map<String, dynamic> errorDetails = responseBody['error'];
        String message = errorDetails['message'];
        switch (message) {
          case 'EMAIL_EXISTS':
            return Response.notFound(
                'That email address is already in use by another account');

          case 'WEAK_PASSWORD : Password should be at least 6 characters':
            return Response.notFound(
                'Your password must be at least 6 characters long');

          default:
            return Response.notFound('Some other error');
        }
      }

      String uid = responseBody['localId'];
      String token = _helpers.createToken(uid);

      return Response.ok(token);
    });
  }
}