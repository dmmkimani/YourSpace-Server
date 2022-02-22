import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'helpers.dart';

class GetBuildingName {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      String building = json.decode(jsonString);

      String path = 'buildings/$building';

      Document buildingDoc = await Helpers().getDocument(path);
      Map<String, dynamic> buildingDetails = buildingDoc.map;

      return Response.ok(json.encode(buildingDetails['name']));
    });
  }
}
