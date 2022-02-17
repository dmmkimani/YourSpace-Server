import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import 'package:firedart/firedart.dart';

import 'function_helpers.dart';

class GetRoomBookings {
  Future<Response> getBookings(Request request) async {
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
              HelperFunctions().getAPI();

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
      return Response.ok(await getDocument(path));
    });
  }

  Future<String> getDocument(String path) async {
    Map<String, dynamic> roomBookings = await Firestore.instance
        .document(path)
        .get()
        .then((Document document) => document.map);

    String bookings = json.encode(roomBookings);
    return bookings;
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
      String timeSlot = HelperFunctions().intToTimeSlot(i);
      emptySlots[timeSlot] = empty;
    }
    return emptySlots;
  }
}
