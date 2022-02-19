import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import 'package:firedart/firedart.dart';

import 'helpers.dart';

class DeleteFromFeed {
  Future<Response> delete(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String userEmail = body['userEmail'].toString();
      String date = body['date'].toString();

      String path = 'users/$userEmail/bookings/$date';

      Map<String, dynamic> booking = await Helpers().getDocument(path);
      booking['deletedFromFeed'] = true;

      await Firestore.instance.document(path).delete();
      await Firestore.instance.document(path).create(booking);

      return Response.ok(json.encode('Booking deleted!'));
    });
  }
}
