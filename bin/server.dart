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
import 'functions/get_user_info.dart';
import 'functions/login.dart';

final _router = Router()
  ..post('/create_account', createAccount)
  ..post('/login', login)
  ..post('/building_details', getBuildingDetails)
  ..post('/room_details', getRoomDetails)
  ..post('/room_bookings', getRoomBookings)
  ..post('/user_info', getUserInfo)
  ..post('/user_bookings', getUserBookings)
  ..post('/book', book)
  ..post('/amend', amendBooking)
  ..post('/cancel', cancelBooking)
  ..post('/delete', deleteFromHistory);

Future<Response> createAccount(Request request) async {
  return CreateAccount().create(request);
}

Future<Response> login(Request request) async {
  return Login().login(request);
}

Future<Response> getBuildingDetails(Request request) async {
  return GetBuildingDetails().get(request);
}

Future<Response> getRoomDetails(Request request) async {
  return GetRoomDetails().get(request);
}

Future<Response> getRoomBookings(Request request) async {
  return GetRoomBookings().get(request);
}

Future<Response> getUserInfo(Request request) async {
  return GetUserInfo().get(request);
}

Future<Response> getUserBookings(Request request) async {
  return GetUserBookings().get(request);
}

Future<Response> book(Request request) async {
  return Book().book(request);
}

Future<Response> amendBooking(Request request) async {
  return AmendBooking().amend(request);
}

Future<Response> cancelBooking(Request request) async {
  return CancelBooking().cancel(request);
}

Future<Response> deleteFromHistory(Request request) async {
  return DeleteFromHistory().delete(request);
}

void main(List<String> args) async {
  final ip = InternetAddress.loopbackIPv4;
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final server = await serve(_handler, ip, 3000);

  Firestore.initialize('wall-mounted-room-calendar');

  print('Server listening on localhost:${server.port}');
}
