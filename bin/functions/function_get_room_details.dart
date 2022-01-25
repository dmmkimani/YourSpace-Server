import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:firedart/firedart.dart';

class GetRoomDetails {
  Future<Response> getRoomDetails(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();
      String room = body['room'].toString();

      Map<String, dynamic> roomDetails = await Firestore.instance
          .document('buildings/' + building + '/rooms/' + room)
          .get()
          .then((Document document) => document.map);

      String details = json.encode(roomDetails);

      return Response.ok(details);
    });
  }
}
