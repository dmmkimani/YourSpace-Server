import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'package:uuid/uuid.dart';

import 'helpers.dart';

class Booking {
  Future<Response> create(Request request) async {
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

      if (int.parse(people) < 1) {
        return Response.forbidden(json.encode(
            'To make a booking, there needs to be one or more people using the space'));
      }

      String roomBookingsPath =
          'buildings/$building/rooms/$room/bookings/$date';

      Map<String, dynamic> bookings =
          await HelperFunctions().getDocument(roomBookingsPath);

      int startHour = HelperFunctions().timeSlotToInt(startTime);

      for (int i = startHour; i < (startHour + duration); i++) {
        String timeSlot = HelperFunctions().intToTimeSlot(i);

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

      Map<String, dynamic> roomDetails = await HelperFunctions()
          .getDocument('buildings/$building/rooms/$room');

      if (int.parse(people) > int.parse(roomDetails['capacity'])) {
        return Response.forbidden(json.encode(
            'This room can only hold ' + roomDetails['capacity'] + ' people.'));
      }

      if (duration <= 0) {
        return Response.forbidden(
            json.encode('A booking must be a minimum of 1 hour.'));
      }

      for (int i = startHour; i < (startHour + duration); i++) {
        String timeSlot = HelperFunctions().intToTimeSlot(i);
        bookings[timeSlot]['booked'] = true;
        bookings[timeSlot]['booker'] = userEmail;
      }

      String userBookingsPath = 'users/$userEmail/bookings/$date';

      Map<String, dynamic> bookingDetails = {
        'id': Uuid().v4(),
        'building': building,
        'room': room,
        'people': people,
        'description': description,
        'startTime': startTime,
        'endTime': HelperFunctions().intToTimeSlot(
            HelperFunctions().timeSlotToInt(startTime) + duration),
        'deletedFromHistory': false,
      };

      await Firestore.instance.document(roomBookingsPath).delete();
      await Firestore.instance.document(roomBookingsPath).create(bookings);

      if (await Firestore.instance.document(userBookingsPath).exists) {
        List<dynamic> userBookings = await HelperFunctions()
            .getDocument(userBookingsPath)
            .then(
                (Map<String, dynamic> documentMap) => documentMap['bookings']);

        userBookings = userBookings.toList();
        userBookings.add(bookingDetails);
        await Firestore.instance
            .document(userBookingsPath)
            .update({'bookings': userBookings});
      } else {
        await Firestore.instance.document(userBookingsPath).create({
          'bookings': [bookingDetails]
        });
      }

      HelperFunctions().updateNumBookings(userEmail);

      return Response.ok(json.encode('Booking successful!\nEnjoy your space!'));
    });
  }
}
