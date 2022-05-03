import 'dart:convert';
import 'package:firedart/firedart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';

/*
  This test can only be ran once
  This is because on the second run, the email new.user@app.com will have been taken
  If you wish to run it a second time, change the email to a different one
*/

String localhost() {
  return 'http://localhost:3000';
}

void main() {
  Firestore.initialize('wall-mounted-room-calendar');
  late Client client;

  setUp(() {
    client = Client();
  });

  group('create test', () {
    test('invalid email test', () async {
      Response response =
          await client.post(Uri.parse(localhost() + '/create_account'),
              body: json.encode({
                'fName': 'test',
                'lName': 'test',
                'email': 'test',
                'password': 'test_user',
              }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(body, 'Please enter a valid email.');
    });

    test('weak password test', () async {
      Response response =
          await client.post(Uri.parse(localhost() + '/create_account'),
              body: json.encode({
                'fName': 'test',
                'lName': 'test',
                'email': 'new.user@app.com',
                'password': 'test',
              }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(body, 'Your password must be at least 6 characters long.');
    });

    test('valid credentials test', () async {
      Response response =
          await client.post(Uri.parse(localhost() + '/create_account'),
              body: json.encode({
                'fName': 'test',
                'lName': 'test',
                'email': 'new.user@app.com',
                'password': 'test_user',
              }));

      String body = json.decode(response.body);
      Map<String, dynamic> userMap = await Firestore.instance
          .document('users/test@app.com')
          .get()
          .then((Document document) => document.map);

      expect(response.statusCode, 200);
      expect(body, TypeMatcher<String>());
      expect(userMap,
          {'admin': false, 'fName': 'test', 'lName': 'test', 'numBookings': 0});
    });

    test('duplicate email test', () async {
      Response response =
          await client.post(Uri.parse(localhost() + '/create_account'),
              body: json.encode({
                'fName': 'test',
                'lName': 'test',
                'email': 'new.user@app.com',
                'password': 'test_user',
              }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(body, 'That email address is already in use by another account.');
    });
  });
}
