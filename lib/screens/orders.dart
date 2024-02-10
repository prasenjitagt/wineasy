import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineasy/providers/socket_data_provider.dart';
import '../components/side_nav_bar.dart';

class Orders extends ConsumerWidget {
  const Orders({Key? key}) : super(key: key);

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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Order Items and Qty
                            SizedBox(
                              width: 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    data[index][0].map<Widget>((eachOrder) {
                                  return Text(
                                    '${eachOrder['item']['productName']} x ${eachOrder['itemCount']}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  );
                                }).toList(),
                              ),
                            ),

                            //Order Status

                            SizedBox(
                              width: 200,
                              child: Text(
                                'Order Time: ${data[index][1]['orderedAt']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),

                            //Ready and Cancel Buttons
                            Row(
                              children: [
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Ready',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 22, 209, 28),
                                        fontSize: 15,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black,
                        )
                      ],
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
