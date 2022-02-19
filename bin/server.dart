import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:firedart/firedart.dart';

import 'functions/book.dart';
import 'functions/create_account.dart';
import 'functions/delete_booking.dart';
import 'functions/get_building_name.dart';
import 'functions/get_room_bookings.dart';
import 'functions/get_room_details.dart';
import 'functions/get_user_bookings.dart';
import 'functions/login.dart';

final _router = Router()
  ..post('/create_account', _createAccount)
  ..post('/login', _login)
  ..post('/building_name', _getBuildingName)
  ..post('/room_details', _getRoomDetails)
  ..post('/room_bookings', _getRoomBookings)
  ..post('/user_bookings', _getUserBookings)
  ..post('/book', _book)
  ..post('/delete', _deleteFromFeed);

Future<Response> _createAccount(Request request) async {
  return CreateAccount().create(request);
}

Future<Response> _login(Request request) async {
  return Login().login(request);
}

Future<Response> _getBuildingName(Request request) async {
  return GetBuildingName().get(request);
}

Future<Response> _getRoomDetails(Request request) async {
  return GetRoomDetails().get(request);
}

Future<Response> _getRoomBookings(Request request) async {
  return GetRoomBookings().get(request);
}

Future<Response> _getUserBookings(Request request) async {
  return GetUserBookings().get(request);
}

Future<Response> _book(Request request) async {
  return Book().book(request);
}

Future<Response> _deleteFromFeed(Request request) async {
  return DeleteFromFeed().delete(request);
}

void main(List<String> args) async {
  final ip = InternetAddress.loopbackIPv4;
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final server = await serve(_handler, ip, 3000);

  Firestore.initialize('wall-mounted-room-calendar');

  print('Server listening on localhost:${server.port}');
}
