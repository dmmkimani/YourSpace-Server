import 'dart:convert';

import 'package:firedart/firedart.dart';
import 'package:shelf/shelf.dart';

import 'function_get_bookings.dart';

class Book {
  Future<Response> book(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();
      String room = body['room'].toString();
      String date = body['date'].toString();
      String startTime = body['startTime'].toString();
      Map<String, dynamic> details = body['details'];
      int duration = details['duration'];

      String path =
          'buildings/' + building + '/rooms/' + room + '/bookings/' + date;

      Map<String, dynamic> bookings =
          json.decode(await GetBookings().getDocument(path));

      int timeSlot = timeSlotToInt(startTime);

      for (int i = timeSlot; i < (timeSlot + duration); i++) {
        String slot = intToTimeSlot(i);

        if (bookings[slot]['available'] == true) {
          if (bookings[slot]['booking']['booked'] == true) {
            return Response.forbidden(
                'Unfortunately, the room is reserved at ' + slot);
          }
        } else {
          return Response.forbidden(
              'Unfortunately, the room is unavailable at ' + slot);
        }
      }

      for (int i = timeSlot; i < (timeSlot + duration); i++) {
        String slot = intToTimeSlot(i);
        bookings[slot]['booking']['booked'] = true;
        bookings[slot]['booking']['details'] = {
          'booker': details['booker'],
          'people': details['people'],
          'description': details['description']
        };
      }

      await Firestore.instance.document(path).delete();
      await Firestore.instance.document(path).create(bookings);

      return Response.ok('Booking successful!');
    });
  }

  int timeSlotToInt(String timeSlot) {
    return int.parse(timeSlot.split(':')[0]);
  }

  String intToTimeSlot(int i) {
    String time = i.toString();
    if (time.length == 2) {
      return time + ':00';
    } else {
      return '0' + time + ':00';
    }
  }

  int getLatestTimeSlot(Map<String, dynamic> bookings) {
    int latestTimeSlot = 0;
    bookings.forEach((timeSlot, data) {
      int currentTimeSlot = timeSlotToInt(timeSlot);
      if (currentTimeSlot > latestTimeSlot) {
        latestTimeSlot = currentTimeSlot;
      }
    });
    return latestTimeSlot;
  }
}
