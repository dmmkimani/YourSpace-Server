import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:firedart/firedart.dart';

import 'functions/function_create_account.dart';
import 'functions/function_get_capacity.dart';
import 'functions/function_login.dart';

final _router = Router()
  ..post('/create_account', _createAccount)
  ..post('/login', _login)
  ..post('/capacity', _getCapacity);

Future<Response> _createAccount(Request request) async {
  return CreateAccount().createAccount(request);
}

Future<Response> _login(Request request) async {
   return Login().login(request);
}

Future<Response> _getCapacity(Request request) async {
  return GetCapacity().getCapacity(request);
}

void main(List<String> args) async {
  final ip = InternetAddress.loopbackIPv4;
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final server = await serve(_handler, ip, 3000);

  Firestore.initialize('wall-mounted-room-calendar');

  print('Server listening on localhost:${server.port}');
}
