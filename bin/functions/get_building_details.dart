import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'helpers.dart';

class GetBuildingDetails {
  Future<Response> get(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      String building = json.decode(jsonString);

      String path = 'buildings/$building';

      Map<String, dynamic> buildingDetails = await Helpers().getDocument(path);

      return Response.ok(json.encode(buildingDetails));
    });
  }
}
