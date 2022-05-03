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

  test('get test', () async {
    Response response = await client.post(
        Uri.parse(localhost() + '/room_bookings'),
        body: json.encode({
          'building': 'the_great_hall',
          'room': 'gh018',
          'date': '18.7.2001'
        }));

    Map<String, dynamic> body = json.decode(response.body);

    expect(response.statusCode, 200);
    expect(body['09:00'], {'available': true, 'booked': false});
    expect(body['10:00'], {'available': true, 'booked': false});
    expect(body['11:00'], {'available': true, 'booked': false});
    expect(body['12:00'], {'available': true, 'booked': false});
    expect(body['13:00'], {'available': true, 'booked': false});
    expect(body['14:00'], {'available': true, 'booked': false});
    expect(body['15:00'], {'available': true, 'booked': false});
    expect(body['16:00'], {'available': true, 'booked': false});
    expect(body['17:00'], {'available': true, 'booked': false});
  });
}
