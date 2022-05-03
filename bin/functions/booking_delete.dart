import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';
import 'helpers.dart';

class DeleteFromHistory {
  Future<Response> delete(Request request) async {
    return await request
        .readAsString(request.encoding)
        .then((String jsonString) async {
      Map<String, dynamic> body = json.decode(jsonString);
      String userEmail = body['userEmail'].toString();
      String id = body['id'].toString();
      String date = body['date'].toString().split('-')[0];

      String path = 'users/$userEmail/bookings/$date';

      List<dynamic> bookings = await HelperFunctions()
          .getDocument(path)
          .then((Map<String, dynamic> documentMap) => documentMap['bookings']);
      bookings = bookings.toList();

      for (int i = 0; i < bookings.length; i++) {
        if (bookings[i]['id'] == id) {
          Map<String, dynamic> booking = bookings.removeAt(i);
          booking['deletedFromHistory'] = true;
          bookings.add(booking);
        }
      }

      await Firestore.instance.document(path).update({'bookings': bookings});

      return Response.ok(null);
    });
  }
}
