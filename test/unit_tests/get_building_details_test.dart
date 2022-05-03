import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';

String localhost() {
  return 'http://localhost:3000';
}

void main() {
  late Client client;

  setUp(() {
    client = Client();
  });

  group('test getBuildingDetails for all buildings', () {
    test('the_great_hall test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('the_great_hall'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'The Great Hall');
    });

    test('school_of_management test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('school_of_management'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'School of Management');
    });

    test('the_college test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('the_college'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'The College');
    });

    test('y_twyni test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('y_twyni'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'Y Twyni');
    });

    test('fulton_house test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('fulton_house'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'Fulton House');
    });

    test('faraday test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('faraday'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'Faraday');
    });

    test('james_callaghan test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('james_callaghan'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'James Callaghan');
    });

    test('keir_hardie test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/building_details'),
          body: json.encode('keir_hardie'));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['name'], 'Keir Hardie');
    });
  });
}
