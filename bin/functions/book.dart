import 'dart:convert';
import 'package:shelf/shelf.dart';

import 'package:firedart/firedart.dart';
import 'package:uuid/uuid.dart';

import 'helpers.dart';

class Book {
  Future<Response> book(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String userEmail = body['userEmail'].toString();
      String building = body['building'].toString();
      String room = body['room'].toString();
      String date = body['date'].toString();
      String people = body['people'].toString();
      String description = body['description'].toString();
      String startTime = body['startTime'].toString();
      int duration = body['duration'];

      if (people == '' || description == '') {
        return Response.forbidden(
            json.encode('Please fill in all the details of your booking.'));
      }

      String path = 'buildings/$building/rooms/$room/bookings/$date';

      //
      // NEED TO CHECK IF THE DOCUMENT EXISTS FIRST
      //

      Document roomDoc = await Helpers().getDocument(path);
      Map<String, dynamic> bookings = roomDoc.map;

      int startHour = Helpers().timeSlotToInt(startTime);

      for (int i = startHour; i < (startHour + duration); i++) {
        String timeSlot = Helpers().intToTimeSlot(i);

        if (bookings[timeSlot]['available'] == true) {
          if (bookings[timeSlot]['booked'] == true) {
            return Response.forbidden(json
                .encode('Unfortunately, the room is reserved at $timeSlot.'));
          }
        } else {
          return Response.forbidden(json
              .encode('Unfortunately, the room is unavailable at $timeSlot.'));
        }
      }

      Map<String, dynamic> roomDetails = await Firestore.instance
          .document('buildings/$building/rooms/$room')
          .get()
          .then((Document document) => document.map);

      if (int.parse(people) > int.parse(roomDetails['capacity'])) {
        return Response.forbidden(json.encode(
            'This room can only hold ' + roomDetails['capacity'] + ' people.'));
      }

      if (duration <= 0) {
        return Response.forbidden(
            json.encode('A booking must be a minimum of 1 hour.'));
      }

      for (int i = startHour; i < (startHour + duration); i++) {
        String timeSlot = Helpers().intToTimeSlot(i);
        bookings[timeSlot]['booked'] = true;
        bookings[timeSlot]['booker'] = userEmail;
      }

      await Firestore.instance.document(path).delete();
      await Firestore.instance.document(path).create(bookings);

      String userPath = 'users/$userEmail/bookings/$date';

      Map<String, dynamic> bookingDetails = {
        'id': Uuid().v4(),
        'building': building,
        'room': room,
        'people': people,
        'description': description,
        'startTime': startTime,
        'endTime': Helpers()
            .intToTimeSlot(Helpers().timeSlotToInt(startTime) + duration),
        'deletedFromHistory': false,
      };

      if (await Firestore.instance.document(userPath).exists) {
        Document userDoc = await Helpers().getDocument(userPath);
        List<dynamic> userBookings = userDoc.map['bookings'];
        userBookings = userBookings.toList();
        userBookings.add(bookingDetails);
        await Firestore.instance.document(userPath).delete();
        await Firestore.instance
            .document(userPath)
            .create({'bookings': userBookings});
      } else {
        await Firestore.instance.document(userPath).create({
          'bookings': [bookingDetails]
        });
      }

      return Response.ok(json.encode('Booking successful!\nEnjoy your space!'));
    });
  }

  int getLatestTimeSlot(Map<String, dynamic> bookings) {
    int latestTimeSlot = 0;
    bookings.forEach((timeSlot, data) {
      int currentTimeSlot = Helpers().timeSlotToInt(timeSlot);
      if (currentTimeSlot > latestTimeSlot) {
        latestTimeSlot = currentTimeSlot;
      }
    });
    return latestTimeSlot;
  }
}
