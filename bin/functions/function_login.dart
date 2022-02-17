import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import 'function_helpers.dart';

class Login {
  Future<Response> login(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> loginInfo = json.decode(jsonString);
      String? email = loginInfo['email'].toString();
      String? password = loginInfo['password'].toString();

      if (HelperFunctions().areInputsEmpty([email, password])) {
        return Response.forbidden(
            json.encode('Please complete your account details'));
      }

      String endpoint =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" +
              HelperFunctions().getAPI();

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
          case 'EMAIL_NOT_FOUND':
            return Response.forbidden(json.encode('That user does not exist'));

          case 'INVALID_PASSWORD':
            return Response.forbidden(json.encode(
                'Please enter a valid email address and password combination'));

          case 'USER_DISABLED':
            return Response.forbidden(
                json.encode('That user account has been disabled'));

          case 'INVALID_EMAIL':
            return Response.forbidden(
                json.encode('Please enter a valid email address'));

          default:
            return Response.forbidden(json.encode(
                'Access to this account has been temporarily disabled due to many '
                'failed login attempts. You can immediately restore it by resetting '
                'your password or you can try again later'));
        }
      }

      String uid = responseBody['localId'];
      String token = HelperFunctions().createToken(uid);

      return Response.ok(json.encode(token));
    });
  }
}
