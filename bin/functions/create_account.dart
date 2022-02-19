import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import 'package:firedart/firedart.dart';

import 'helpers.dart';
import 'helpers_login.dart';

class CreateAccount {
  Future<Response> create(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> accountInfo = json.decode(jsonString);
      String fName = accountInfo['fName'].toString();
      String lName = accountInfo['lName'].toString();
      String email = accountInfo['email'].toString();
      String password = accountInfo['password'].toString();

      if (LoginHelpers().areInputsEmpty([fName, lName, email, password])) {
        return Response.forbidden(
            json.encode('Please fill in all the text fields'));
      }

      String endpoint =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" +
              Helpers().getAPI();

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
            return Response.forbidden(json.encode(
                'That email address is already in use by another account'));

          case 'WEAK_PASSWORD : Password should be at least 6 characters':
            return Response.forbidden(json
                .encode('Your password must be at least 6 characters long'));

          default:
            return Response.forbidden(json.encode('Some other error'));
        }
      }

      await Firestore.instance
          .document('users/$email')
          .create({'admin': false, 'fName': fName, 'lName': lName});

      String uid = responseBody['localId'];
      String token = LoginHelpers().createToken(uid);

      return Response.ok(token);
    });
  }
}
