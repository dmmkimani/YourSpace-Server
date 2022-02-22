import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:firedart/firedart.dart';

import 'functions/book.dart';
import 'functions/booking_amend.dart';
import 'functions/booking_cancel.dart';
import 'functions/create_account.dart';
import 'functions/booking_delete.dart';
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
  ..post('/amend', _amendBooking)
  ..post('/cancel', _cancelBooking)
  ..post('/delete', _deleteFromHistory);

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

Future<Response> _amendBooking(Request request) async {
  return AmendBooking().amend(request);
}

Future<Response> _cancelBooking(Request request) async {
  return CancelBooking().cancel(request);
}

Future<Response> _deleteFromHistory(Request request) async {
  return DeleteFromHistory().delete(request);
}

void main(List<String> args) async {
  final ip = InternetAddress.loopbackIPv4;
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final server = await serve(_handler, ip, 3000);

  Firestore.initialize('wall-mounted-room-calendar');

  print('Server listening on localhost:${server.port}');
}
