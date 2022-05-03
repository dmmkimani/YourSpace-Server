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

  group('getRoomDetails test', () {
    test('gh001 test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'the_great_hall', 'room': 'gh001'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '128');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });

    test('som111 test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'school_of_management', 'room': 'som111'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '50');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });

    test('college_025 test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'the_college', 'room': 'college_025'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '60');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });

    test('y_twyni 108 test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'y_twyni', 'room': 'y_twyni_108'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '160');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });

    test('marino_room test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'fulton_house', 'room': 'marino_room'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '20');
      expect(body['amenities']['microphone'], false);
      expect(body['amenities']['pc'], false);
      expect(body['amenities']['projector'], false);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], false);
    });

    test('faraday_lecture_theatre test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'faraday', 'room': 'faraday_lecture_theatre'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '260');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });

    test('jc_b-04 test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'james_callaghan', 'room': 'jc_b-04'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '20');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });

    test('kh_303 test', () async {
      Response response = await client.post(
          Uri.parse(localhost() + '/room_details'),
          body: json.encode({'building': 'keir_hardie', 'room': 'kh_303'}));

      Map<String, dynamic> body = json.decode(response.body);

      expect(response.statusCode, 200);
      expect(body['available'], true);
      expect(body['capacity'], '48');
      expect(body['amenities']['microphone'], true);
      expect(body['amenities']['pc'], true);
      expect(body['amenities']['projector'], true);
      expect(body['amenities']['screen'], false);
      expect(body['amenities']['speakers'], true);
    });
  });
}
