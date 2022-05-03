import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'helpers.dart';

class GetRoomDetails {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();
      String room = body['room'].toString();

      Map<String, dynamic> roomDetails =
          await HelperFunctions().getDocument('buildings/$building/rooms/$room');

      return Response.ok(json.encode(roomDetails));
    });
  }
}
