import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/services/socket_service.dart';

final providerOfSocket = StreamProvider((ref) async* {
  StreamController stream = StreamController();
  final orderDataBox = Hive.box('orderDataBox');

  List<dynamic> orders =
      orderDataBox.get('orderData', defaultValue: <dynamic>[]);

  SocketService().socket.on('orderToKitchen', (dataFromServer) {
    stream.add(dataFromServer);
  });

  await for (final value in stream.stream) {
    orders.add(value); // Append new data to the existing list
    orderDataBox.put(
        'orderData', orders); // Store the updated list back into Hive

    yield List.from(orders); // Yield a copy of the updated list
  }
});
