import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'helpers.dart';

class GetUserInfo {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      String userEmail = json.decode(jsonString);

      Map<String, dynamic> userInfo =
          await HelperFunctions().getDocument('users/$userEmail');

      String fullName = userInfo['fName'] + ' ' + userInfo['lName'];

      userInfo.remove('admin');
      userInfo.remove('fName');
      userInfo.remove('lName');

      userInfo['email'] = userEmail;
      userInfo['name'] = fullName;

      return Response.ok(json.encode(userInfo));
    });
  }
}
