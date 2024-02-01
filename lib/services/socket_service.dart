import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket = IO.io('http://localhost:4848', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  initConnection() {
    //connect to the socket
    socket.connect();

    //if connected then
    socket.onConnect((data) {
      print(" socket connected");
    });

    //on errror
    socket.onerror((data) {
      print('error connecting to socket');
    });

    //on disconnection
    socket.onDisconnect((data) {
      print('disconnected');
    });
  }
}
