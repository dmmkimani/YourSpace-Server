import 'package:firedart/firedart.dart';

class Helpers {
  String getAPI() {
    return "AIzaSyDxTkqc6xYLR3PibbQhq3ORw2uzBgeUGQc";
  }

  Future<Document> getDocument(String path) async {
    /*
    Map<String, dynamic> documentMap = await Firestore.instance
        .document(path)
        .get()
        .then((Document document) => document.map);
    */

    Document document = await Firestore.instance.document(path).get();

    return document;
  }

  Future<List<Document>> getCollection(String path) async {
    List<Document> documents = await Firestore.instance
        .collection(path)
        .get()
        .then((Page<Document> collection) => collection.toList());

    return documents;
  }

  String intToTimeSlot(int i) {
    String time = i.toString();
    if (time.length == 2) {
      return time + ':00';
    } else {
      return '0' + time + ':00';
    }
  }
}
