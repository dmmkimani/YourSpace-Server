import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'helpers.dart';

class GetUserBookings {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      String userEmail = json.decode(jsonString);

      String path = 'users/$userEmail/bookings';
      List<Document> documents = await Helpers().getCollection(path);

      if (documents.isEmpty) {
        return Response.notFound(json.encode('No bookings found'));
      } else {
        Map<String, dynamic> userBookings = {};

        for (int i = 0; i < documents.length; i++) {
          Document bookingDate = documents[i];
          String date = bookingDate.path.split(path + '/')[1];
          List<dynamic> bookings = bookingDate.map['bookings'];
          for (int j = 0; j < bookings.length; j++) {
            Map<String, dynamic> details = bookings[j];
            if (!details['deletedFromHistory']) {
              String startTime = details['startTime'];
              String dateTime = '$date-$startTime';
              userBookings[dateTime] = details;
            }
          }
        }

        if (userBookings.isEmpty) {
          return Response.notFound(json.encode('All bookings deleted from history'));
        } else {
          return Response.ok(json.encode(userBookings));
        }
      }
    });
  }
}
