import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'helpers.dart';

class AmendBooking {
  Future<Response> amend(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String userEmail = body['userEmail'].toString();
      String id = body['id'].toString();
      String building = body['building'].toString();
      String room = body['room'].toString();
      String date = body['date'].toString().split('-')[0];
      String people = body['people'].toString();
      String description = body['description'].toString();

      if (people == '' || description == '') {
        return Response.forbidden(
            json.encode('Please fill in all the details of your booking.'));
      }

      String roomPath = 'buildings/$building/rooms/$room';
      Document roomDoc = await Helpers().getDocument(roomPath);
      Map<String, dynamic> roomDetails = roomDoc.map;

      if (int.parse(people) > int.parse(roomDetails['capacity'])) {
        return Response.forbidden(json.encode(room.toUpperCase() +
            ' can only hold ' +
            roomDetails['capacity'] +
            ' people.'));
      }

      String userPath = 'users/$userEmail/bookings/$date';

      Document bookingDocument = await Helpers().getDocument(userPath);
      List<dynamic> bookings = bookingDocument.map['bookings'];
      bookings = bookings.toList();

      for (int i = 0; i < bookings.length; i++) {
        if (bookings[i]['id'] == id) {
          Map<String, dynamic> booking = bookings.removeAt(i);
          booking['people'] = people;
          booking['description'] = description;
          bookings.add(booking);
        }
      }

      await Firestore.instance.document(userPath).delete();
      await Firestore.instance.document(userPath).create({'bookings': bookings});

      return Response.ok(json.encode('Booking amended.'));
    });
  }
}
