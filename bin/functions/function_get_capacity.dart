import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:firedart/firedart.dart';

class GetCapacity {
  Future<Response> getCapacity(Request request) async {
    return await request.readAsString(request.encoding).then((String jsonString) async {
      Map<String,dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();
      String room = body['room'].toString();

      Map<String,dynamic> details =
      await Firestore.instance.document('buildings/' + building + '/' + room + '/details')
          .get()
          .then((Document document) => document.map);

      String capacity = details['capacity'];

      return Response.ok(capacity);
    });
  }
}