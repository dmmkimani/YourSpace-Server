import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import 'helpers.dart';

class ForgotPassword {
  Future<Response> reset(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> emailAddress = json.decode(jsonString);
      String? email = emailAddress['email'].toString();

      String endpoint =
          'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=' +
              await Helpers().getAPI();

      http.Response response = await http.post(Uri.parse(endpoint),
          headers: {'Content-type': 'application/json'},
          body: json.encode({'requestType': 'PASSWORD_RESET', 'email': email}));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('error')) {
        Map<String, dynamic> errorDetails = responseBody['error'];
        String message = errorDetails['message'];
        switch (message) {
          case 'EMAIL_NOT_FOUND':
            return Response.notFound(
                json.encode('There is no account registered with that email.'));
        }
      }
      return Response.ok('');
    });
  }
}
