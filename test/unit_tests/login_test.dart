import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';

/*
  test@app.com is a user I created specifically for testing functionality in the server
  disabled@app.com is a user I created and then disabled through the Firebase console
*/

String localhost() {
  return 'http://localhost:3000';
}

void main() {
  late Client client;

  setUp(() {
    client = Client();
  });

  group('login test', () {
    group('empty inputs test', () {
      test('empty inputs test', () async {
        Response response = await client.post(Uri.parse(localhost() + '/login'),
            body: json.encode({
              'email': '',
              'password': '',
            }));

        String body = json.decode(response.body);

        expect(response.statusCode, 403);
        expect(body, 'Please complete your account details.');
      });

      test('empty inputs test', () async {
        Response response = await client.post(Uri.parse(localhost() + '/login'),
            body: json.encode({
              'email': 'email@app.com',
              'password': '',
            }));

        String body = json.decode(response.body);

        expect(response.statusCode, 403);
        expect(body, 'Please complete your account details.');
      });

      test('empty inputs test', () async {
        Response response = await client.post(Uri.parse(localhost() + '/login'),
            body: json.encode({
              'email': '',
              'password': 'password',
            }));

        String body = json.decode(response.body);

        expect(response.statusCode, 403);
        expect(body, 'Please complete your account details.');
      });
    });

    test('invalid email test', () async {
      Response response = await client.post(Uri.parse(localhost() + '/login'),
          body: json.encode({
            'email': 'not.a.user@app.com',
            'password': 'password',
          }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(body, 'That user does not exist.');
    });

    test('invalid password test', () async {
      Response response = await client.post(Uri.parse(localhost() + '/login'),
          body: json.encode({
            'email': 'test@app.com',
            'password': 'wrong.password',
          }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(
          body, 'Please enter a valid email address and password combination.');
    });

    test('disabled user test', () async {
      Response response = await client.post(Uri.parse(localhost() + '/login'),
          body: json.encode({
            'email': 'disabled@app.com',
            'password': 'password',
          }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(body, 'That user account has been disabled.');
    });

    test('invalid email test', () async {
      Response response = await client.post(Uri.parse(localhost() + '/login'),
          body: json.encode({
            'email': 'test',
            'password': 'password',
          }));

      String body = json.decode(response.body);

      expect(response.statusCode, 403);
      expect(body, 'Please enter a valid email address.');
    });

    test('valid credentials test', () async {
      Response response = await client.post(Uri.parse(localhost() + '/login'),
          body: json.encode({
            'email': 'test@app.com',
            'password': 'test_user',
          }));

      String body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body, TypeMatcher<String>());
    });
  });
}
