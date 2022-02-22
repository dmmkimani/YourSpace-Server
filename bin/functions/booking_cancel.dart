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

      String userPath = 'users/$userEmail/bookings/$date';
      Document userDoc = await Helpers().getDocument(userPath);
      List<dynamic> userBookings = userDoc.map['bookings'];
      userBookings = userBookings.toList();

      for (int i = 0; i < userBookings.length; i++) {
        if (userBookings[i]['id'] == id) {
          userBookings.removeAt(i);
        }
      }

      String roomPath = 'buildings/$building/rooms/$room/bookings/$date';
      Document roomDoc = await Helpers().getDocument(roomPath);
      Map<String, dynamic> roomBookings = roomDoc.map;

      int startHour = Helpers().timeSlotToInt(startTime);

      for (int i = startHour; i < (startHour + duration); i++) {
        String timeSlot = Helpers().intToTimeSlot(i);
        Map<String, dynamic> slotInfo = roomBookings[timeSlot];
        slotInfo['booked'] = false;
        slotInfo.remove('booker');
        roomBookings[timeSlot] = slotInfo;
      }

      await Firestore.instance.document(userPath).delete();
      await Firestore.instance
          .document(userPath)
          .create({'bookings': userBookings});

      await Firestore.instance.document(roomPath).delete();
      await Firestore.instance.document(roomPath).create(roomBookings);

      return Response.ok(null);
    });
  }
}
