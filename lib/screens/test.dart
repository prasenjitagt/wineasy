import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/side_nav_bar.dart';
import './../providers/socket_data_provider.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: const SideNavBar(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<SocketDataProvider>(
            builder: (context, socketDataFromProvider, child) => Center(
                  child: Text('data: ${socketDataFromProvider.socketData}'),
                )));
  }
}

/*

 Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Width: $width'),
            const SizedBox(height: 20),
            Consumer<SocketDataProvider>(
              builder: (context, socketDataProvider, child) {
                // Access the socket data using socketDataProvider.socketData
                List<dynamic> socketData = socketDataProvider.socketData;

                // Use the socketData in your UI
                return Text('Socket Data: $socketData');
              },
            ),
          ],
        ),
      ),

*/
