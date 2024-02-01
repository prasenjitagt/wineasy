import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/services/socket_service.dart';

final providerOfSocket = StreamProvider((ref) async* {
  StreamController stream = StreamController();

  SocketService().socket.on('orderToKitchen', (dataFromServer) {
    stream.add(dataFromServer);
  });

  await for (final value in stream.stream) {
    yield value;
  }
});