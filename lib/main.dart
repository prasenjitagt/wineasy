import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/socket_data_provider.dart';
import 'package:wineasy/screens/dashboard.dart';
import 'package:wineasy/screens/test.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final player = AudioPlayer();
  IO.Socket socket = IO.io('http://localhost:4848', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  late BuildContext _providerContext;

  @override
  void initState() {
    super.initState();
    connectToSocketServer(context);
  }

  void connectToSocketServer(BuildContext context) {
    // Store the context in a variable
    _providerContext = context;

    socket.connect();

    socket.onConnect((data) {
      print('connected');

      socket.on('orderToKitchen', (orders) async {
        // Access the SocketDataProvider and set the socket data using the stored context
        Provider.of<SocketDataProvider>(_providerContext, listen: false)
            .setSocketData(orders);

        // Play the sound when order arrives
        await player.play(AssetSource('music/alertTone1.mp3'));
      });
    });

    socket.onDisconnect((data) => {print('disconnected')});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Test(),
        ),
      ),
    );
  }
}
