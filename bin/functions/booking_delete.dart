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

      Document bookingDocument = await Helpers().getDocument(path);
      List<dynamic> bookings = bookingDocument.map['bookings'];
      bookings = bookings.toList();

      for (int i = 0; i < bookings.length; i++) {
        if (bookings[i]['id'] == id) {
          Map<String, dynamic> booking = bookings.removeAt(i);
          booking['deletedFromHistory'] = true;
          bookings.add(booking);
        }
      }

      await Firestore.instance.document(path).delete();
      await Firestore.instance.document(path).create({'bookings': bookings});


      return Response.ok(null);
    });
  }
}
