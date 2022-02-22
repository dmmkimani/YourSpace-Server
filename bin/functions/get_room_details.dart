import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'helpers.dart';

class GetRoomDetails {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();
      String room = body['room'].toString();

      String path = 'buildings/$building/rooms/$room';
      Document roomDoc = await Helpers().getDocument(path);
      Map<String, dynamic> roomDetails = roomDoc.map;

      return Response.ok(json.encode(roomDetails));
    });
  }
}
