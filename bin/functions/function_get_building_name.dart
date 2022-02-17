import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:firedart/firedart.dart';

class GetBuildingName {
  Future<Response> getName(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String building = body['building'].toString();

      String path = 'buildings/$building';

      Map<String, dynamic> buildingDetails = await Firestore.instance
          .document(path)
          .get()
          .then((Document document) => document.map);

      return Response.ok(json.encode(buildingDetails['name']));
    });
  }
}
