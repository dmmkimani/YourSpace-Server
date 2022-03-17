import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'helpers.dart';

class CancelBooking {
  Future<Response> cancel(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String userEmail = body['userEmail'].toString();
      String id = body['id'].toString();
      String building = body['building'].toString();
      String room = body['room'].toString();
      String date = body['date'].toString().split('-')[0];
      String startTime = body['startTime'].toString();
      int duration = body['duration'];

      String userBookingsPath = 'users/$userEmail/bookings/$date';
      List<dynamic> userBookings = await Helpers()
          .getDocument(userBookingsPath)
          .then((Map<String, dynamic> documentMap) => documentMap['bookings']);
      userBookings = userBookings.toList();

      for (int i = 0; i < userBookings.length; i++) {
        if (userBookings[i]['id'] == id) {
          userBookings.removeAt(i);
        }
      }

      String roomPath = 'buildings/$building/rooms/$room/bookings/$date';
      Map<String, dynamic> roomBookings = await Helpers().getDocument(roomPath);

      int startHour = Helpers().timeSlotToInt(startTime);

      for (int i = startHour; i < (startHour + duration); i++) {
        String timeSlot = Helpers().intToTimeSlot(i);
        Map<String, dynamic> slotInfo = roomBookings[timeSlot];
        slotInfo['booked'] = false;
        slotInfo.remove('booker');
        roomBookings[timeSlot] = slotInfo;
      }

      await Firestore.instance
          .document(userBookingsPath)
          .update({'bookings': userBookings});

      await Firestore.instance.document(roomPath).delete();
      await Firestore.instance.document(roomPath).create(roomBookings);

      Helpers().updateNumBookings(userEmail);

      return Response.ok(null);
    });
  }
}
