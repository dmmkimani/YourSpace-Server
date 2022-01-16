import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class HelperFunctions {
  String getAPI() {
    return "AIzaSyDxTkqc6xYLR3PibbQhq3ORw2uzBgeUGQc";
  }

  String createToken(String uid) {
    final String serviceAccountEmail = 'firebase-adminsdk-nct8x@wall-mounted-room-calendar.iam.gserviceaccount.com';
    String aud = 'https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit';
    final DateTime issuedAt = DateTime.now();

    final jwt = JWT({
      'iss' : serviceAccountEmail,
      'sub' : serviceAccountEmail,
      'aud' : aud,
      'iat' : (issuedAt.millisecondsSinceEpoch / 1000).floor(),
      'exp' : (issuedAt.millisecondsSinceEpoch / 1000).floor() + (60 * 30),
      'uid' : uid,
      'claims' : {}
    });

    return jwt.sign(RSAPrivateKey(getPrivateKey()), algorithm: JWTAlgorithm.RS256);
  }

  String getPrivateKey() {
    String privateKey =
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCyzSj8JEU6PJsR"
        "\n33FzcUwfmc0WEHWiRd5Ua6gy7tQeHR7ygtVz6V7CoAK4Y6g4fA8ugFdC5TVGjdFW\nUrlloU4m2oGNNgjdhg/h+f/gQ3"
        "dq8Q4lkDgpcGVOdj2c3ocklvwInkbzqIRvANrS\nsc8a1+0KqILn1+aLfILdIIoy/X+YFADWF+lTkN3qPRM/KDTBMpHU+fr"
        "SOJkBl1SD\nI1RHqdKV4w4BaBOEPTL4TGpj+qVBzE+BxL3MBdgZxXqE/I1Vwk3FHZcMXat74Peb\nqinQNoYlCjtuXBgMbi"
        "+LQahw1h2PLj/p5t7VvKkM9+BCBUMA3ywKZnPWlVIQTQvx\n+Eftr3FFAgMBAAECggEAG3xbSQtgUvf/FIvHOmpXu+HeO36T"
        "PrtD1rFn/VBmbiym\n1bvUCUn+JagIUwUK1ogHo2vaPi/S9UIWxJDZ7CwUQffEA4ujaD5UEbZnJbfpUxi0\nRoT5hTFAeYP"
        "Gq+cvWioVm1ONb6ZfmVrFyK7JugQobcOCwBYZ3CZrTYfThsweQafL\nwgY28hUjf/OGpSmM9ITSLcqK8frYI9kRr75ajjIpkh"
        "MnCYmQZDg7nKVSpUseAMyd\noNRzgOK2NVKqpXxypC6XA+CIbSn4EMqW8G0Yr9pLcLWgUsIVMlRqPa7EuaKMNB89\nl1h86Up"
        "zbXgWwIueB9StjUcnxPn/9a0kUJyTnjfyfwKBgQDZQkPZO3D3qX0ZE8Jo\n9j8uWhKPxn/1MqG5hEX/Q0k08qIUsqvgSr2xGl"
        "pap53sSiDCAr7RWzHt+wpzb0NT\nDUR37pydd2Hb7ZUL/oa60C4pvImNF23kBoNzq7BdsHgeni5hBFNw+IqRwuYolX4W\nKRK"
        "5GWVGPiSoTPEmehJTkhhKuwKBgQDSr1YNUSGgEPonDX86q6nE0BmzLGedZmoc\n0tOrHrXF3phE+cwfJ9jhh1J5lMDBwv2hjy"
        "6sgvcuo5szmbrMxcKnt+U5n+ZyfsrH\nAmLrWUAEARrYyoNtu6a+64xnHLpkqzXgLYY1hX6CESyb7AudHxVA6+4OK/r848SJ"
        "\nrbII3pFz/wKBgEwKb2jm7yEfx1MxoUfPeEmm6Pw9g6e0cvpVm5I+YK8RhT0tVA8K\n2d3U1W8JX7LGNzTwdQ0dmBotVXkV"
        "pkC5Ug+QCmzqzeuF+jbafRmBp8af4JzraGD5\nDqU7oF0KWOCOiLkYJIRT2VwvFRN7T0g+U/lJNDMjqPznAThwXV22sp3lAoG"
        "BAMMA\nChOVThwK2p2evm2dSSqiuca+iMCEdB5tfABcEj4sAp+E3MrRZMmJKGrjpW0xfvMz\nxS1iokoGn7Woyd6SA9KcQIuPV"
        "goPFLwRl2DhYIDUTPbuqaq9Dl6TQYaGbnaSiPEO\n8bND9Y2JO9KtLSqmBFPsio+PYWUDo3sSyz+uUM4dAoGBANSKviBkGbn6"
        "CrJ9rq3i\nSB/k4ROoHy2gjNrQFfu0KV2rhCfZtENLRpKYHh7KiUPeCO6WMIXDRlQ4EwfsR4/7\nfVCxxzqnbN/eMGOUkxf0r"
        "LRXLRXloE4kThT6n5Qo4PRNpAAoHhSXuaPb0I6cGJJZ\ni0cwQ9c82hKqtCXrLPJk/MTk\n-----END PRIVATE KEY-----\n";

    return privateKey;
  }
}