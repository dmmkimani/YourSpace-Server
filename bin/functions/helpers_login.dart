import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'helpers.dart';

class LoginHelpers {
  bool areInputsEmpty(List<String> inputs) {
    for (int i = 0; i < inputs.length; i++) {
      String input = inputs[i];
      if (input.isEmpty) {
        return true;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> getResources() async {
    Map<String, dynamic> resources = await Helpers().getDocument('app/jwt');
    return resources;
  }

  Future<String> createToken(String uid) async {
    Map<String, dynamic> resources = await getResources();
    final DateTime issuedAt = DateTime.now();

    final jwt = JWT({
      'iss' : resources['iss'],
      'sub' : resources['iss'],
      'aud' : resources['aud'],
      'iat' : (issuedAt.millisecondsSinceEpoch / 1000).floor(),
      'exp' : (issuedAt.millisecondsSinceEpoch / 1000).floor() + (60 * 30),
      'uid' : uid,
      'claims' : {}
    });

    return jwt.sign(RSAPrivateKey(resources['key']), algorithm: JWTAlgorithm.RS256);
  }
}