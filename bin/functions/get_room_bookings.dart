import 'dart:convert';
import 'package:shelf/shelf.dart';
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

      bool documentExists = await Firestore.instance.document(path).exists;

      if (!documentExists) {
        return Response.ok(await createDocument(path));
      }

      return Response.ok(
          json.encode(await HelperFunctions().getDocument(path)));
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
      String timeSlot = HelperFunctions().intToTimeSlot(i);
      emptySlots[timeSlot] = empty;
    }
    return emptySlots;
  }
}
