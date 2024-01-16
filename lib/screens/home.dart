import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController messageFromFlutter = TextEditingController();
  late String incomingData;

  final socket_io.Socket _socket = socket_io.io('http://localhost:8080/',
      socket_io.OptionBuilder().setTransports(['websocket']).build());

  _connectSocket() {
    _socket.connect();
    _socket
        .onConnect((data) => {debugPrint('socket io connection established')});
    _socket.onConnectError(
        (data) => debugPrint('socket io connection error: $data'));
    _socket.onDisconnect((data) => debugPrint('socket io connection broken'));
  }

  _sendMessage() {
    _socket.emit('flutterMsg', messageFromFlutter.text);
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          TextField(
            controller: messageFromFlutter,
          ),
          ElevatedButton(onPressed: _sendMessage, child: const Text('send')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _socket.disconnect();
              },
              child: const Text('back'))
        ],
      ),
    ));
  }
}
