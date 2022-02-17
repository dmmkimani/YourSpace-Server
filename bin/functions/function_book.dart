import 'dart:convert';

import 'package:firedart/firedart.dart';
import 'package:shelf/shelf.dart';

import 'function_get_room_bookings.dart';
import 'function_helpers.dart';

class Book {
  Future<Response> book(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String booker = body['booker'].toString();
      String date = body['date'].toString();
      String building = body['building'].toString();
      String room = body['room'].toString();
      String people = body['people'].toString();
      String description = body['description'].toString();
      String startTime = body['startTime'].toString();
      int duration = body['duration'];

      if (people == '' || description == '') {
        return Response.forbidden(
            'Please fill in all the details of your booking');
      }

      String path = 'buildings/$building/rooms/$room/bookings/$date';

      Map<String, dynamic> bookings =
          json.decode(await GetRoomBookings().getDocument(path));

      int start = timeSlotToInt(startTime);

      for (int i = start; i < (start + duration); i++) {
        String slot = HelperFunctions().intToTimeSlot(i);

        if (bookings[slot]['available'] == true) {
          if (bookings[slot]['booked'] == true) {
            return Response.forbidden(
                json.encode('Unfortunately, the room is reserved at ' + slot));
          }
        } else {
          return Response.forbidden(
              json.encode('Unfortunately, the room is unavailable at ' + slot));
        }
      }

      Map<String, dynamic> roomDetails = await Firestore.instance
          .document('buildings/$building/rooms/$room')
          .get()
          .then((Document document) => document.map);

      if (int.parse(people) > int.parse(roomDetails['capacity'])) {
        return Response.forbidden(json.encode(
            'This room can only hold ' + roomDetails['capacity'] + ' people'));
      }

      if (duration <= 0) {
        return Response.forbidden(
            json.encode('A booking must be a minimum of 1 hour'));
      }

      for (int i = start; i < (start + duration); i++) {
        String slot = HelperFunctions().intToTimeSlot(i);
        bookings[slot]['booked'] = true;
        bookings[slot]['booker'] = booker;
      }

      await Firestore.instance.document(path).delete();
      await Firestore.instance.document(path).create(bookings);

      String userPath = 'users/$booker/bookings/$date';

      Map<String, dynamic> bookingDetails = {
        'building': building,
        'room': room,
        'people': people,
        'description': description,
        'from': startTime,
        'to':
            HelperFunctions().intToTimeSlot(timeSlotToInt(startTime) + duration)
      };

      await Firestore.instance.document(userPath).create(bookingDetails);

      return Response.ok(json.encode('Booking successful!\nEnjoy your space!'));
    });
  }

  int timeSlotToInt(String timeSlot) {
    return int.parse(timeSlot.split(':')[0]);
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
