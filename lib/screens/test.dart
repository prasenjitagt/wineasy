import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/providers/socket_data_provider.dart';
import '../components/side_nav_bar.dart';

class Test extends ConsumerWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(providerOfSocket);

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: orderData.when(
          data: (data) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data[index].map<Widget>((eachOrder) {
                          return Text(
                            '${eachOrder['item']['productName']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                });
          },
          error: (_, __) {
            print(_.toString());
            return const Text('Error');
          },
          loading: () => const Center(
                  child: Text(
                'No Orders Yet ',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
              ))),
    );
  }
}
