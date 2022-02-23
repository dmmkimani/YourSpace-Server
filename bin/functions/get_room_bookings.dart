import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import 'package:firedart/firedart.dart';

import 'helpers.dart';

class GetRoomBookings {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();
      String room = body['room'].toString();
      String date = body['date'].toString();

      String path = 'buildings/$building/rooms/$room/bookings/$date';

      String endpoint =
          'https://firestore.googleapis.com/v1/projects/wall-mounted-room-calendar/databases/(default)/documents/' +
              path +
              '?key=' +
              Helpers().getAPI();

      http.Response response = await http.get(Uri.parse(endpoint),
          headers: {'Content-type': 'application/json'});

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('error')) {
        Map<String, dynamic> errorDetails = responseBody['error'];
        String status = errorDetails['status'];
        switch (status) {
          case 'NOT_FOUND':
            return Response.ok(await createDocument(path));

          default:
            return Response.notFound(json.encode('Something went wrong!'));
        }
      }
      return Response.ok(json.encode(await Helpers().getDocument(path)));
    });
  }

  Future<String> createDocument(String path) async {
    Map<String, dynamic> newDocument = await Firestore.instance
        .document(path)
        .create(createEmptySlots())
        .then((document) => document.map);

    String bookings = json.encode(newDocument);
    return bookings;
  }

  Map<String, dynamic> createEmptySlots() {
    Map<String, dynamic> emptySlots = {};
    Map<String, dynamic> empty = {'available': true, 'booked': false};
    for (int i = 9; i <= 17; i++) {
      String timeSlot = Helpers().intToTimeSlot(i);
      emptySlots[timeSlot] = empty;
    }
    return emptySlots;
  }
}
