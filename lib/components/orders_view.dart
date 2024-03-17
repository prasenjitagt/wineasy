import 'package:flutter/material.dart';

class OrdersView extends StatelessWidget {
  final List orderDataFromHive;
  const OrdersView({super.key, required this.orderDataFromHive});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Order ID
                SizedBox(
                  width: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Order ID',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                //Order Items and Qty
                SizedBox(
                  width: 400,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Items',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                //Order Status
                SizedBox(
                  width: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Order Time',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Status',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                //Ready and Cancel Buttons
                SizedBox(
                  width: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Action',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: orderDataFromHive.length,
              itemBuilder: (context, index) {
                //Unique ID of every order
                int uuid = orderDataFromHive[index][1]['uniqueId'];
                String orderedAt = orderDataFromHive[index][1]['orderedAt'];
                String orderStatus = orderDataFromHive[index][1]['orderStatus'];
                // String productName =

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Order ID
                          SizedBox(
                            width: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$uuid',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),

                          //Order Items and Qty
                          SizedBox(
                            width: 400,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: orderDataFromHive[index][0]
                                    .map<Widget>((eachOrder) {
                                  return Text(
                                    '${eachOrder['item']['productName']} x ${eachOrder['itemCount']}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          //Order Status
                          SizedBox(
                            width: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                orderedAt,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                orderStatus,
                                style: statusColor(orderStatus),
                              ),
                            ),
                          ),
                          //Ready and Cancel Buttons
                          Row(
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    print(uuid);
                                  },
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
                        thickness: 1,
                        color: Color.fromARGB(255, 143, 140, 140),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

TextStyle statusColor(String orderStatus) {
  if (orderStatus == 'pending') {
    return const TextStyle(
        color: Color.fromARGB(255, 192, 126, 3),
        fontSize: 15,
        fontWeight: FontWeight.w700);
  } else if (orderStatus == 'canceled') {
    return const TextStyle(
        color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700);
  } else {
    return const TextStyle(
        color: Colors.green, fontSize: 15, fontWeight: FontWeight.w700);
  }
}
