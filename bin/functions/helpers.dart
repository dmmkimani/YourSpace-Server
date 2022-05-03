import 'package:firedart/firedart.dart';

class HelperFunctions {
  Future<String> getAPI() async {
    Map<String, dynamic> apiDocument = await getDocument('app/api');
    return apiDocument['key'];
  }

  Future<Map<String, dynamic>> getDocument(String path) async {
    Map<String, dynamic> documentMap = await Firestore.instance
        .document(path)
        .get()
        .then((Document document) => document.map);

    return documentMap;
  }

  Future<List<Document>> getCollection(String path) async {
    List<Document> documents = await Firestore.instance
        .collection(path)
        .get()
        .then((Page<Document> collection) => collection.toList());

    return documents;
  }

  void updateNumBookings(String userEmail) async {
    String bookingsPath = 'users/$userEmail/bookings';
    List<Document> documents = await getCollection(bookingsPath);

    int numBookings = 0;

    for (int i = 0; i < documents.length; i++) {
      Document bookingDate = documents[i];
      List<dynamic> bookings = bookingDate.map['bookings'];
      numBookings += bookings.length;
    }

    String userPath = 'users/$userEmail';
    Map<String, dynamic> userDetails = await getDocument(userPath);
    userDetails['numBookings'] = numBookings;

    await Firestore.instance.document(userPath).update(userDetails);
  }

  String intToTimeSlot(int i) {
    String time = i.toString();
    if (time.length == 2) {
      return time + ':00';
    } else {
      return '0' + time + ':00';
    }
  }

  int timeSlotToInt(String timeSlot) {
    return int.parse(timeSlot.split(':')[0]);
  }
}
