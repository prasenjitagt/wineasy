import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OrdersView extends StatefulWidget {
  final List orderDataFromHive;
  const OrdersView({super.key, required this.orderDataFromHive});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 60,
              color: const Color.fromARGB(255, 255, 131, 6),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Order ID
                  SizedBox(
                    width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Order ID',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Status',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.orderDataFromHive.length,
              itemBuilder: (context, index) {
                //Unique ID of every order
                int uuid = widget.orderDataFromHive[index][1]['uniqueId'];
                String orderedAt =
                    widget.orderDataFromHive[index][1]['orderedAt'];
                String orderStatus =
                    widget.orderDataFromHive[index][1]['orderStatus'];
                // String productName =

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          color: _hoveredIndex == index
                              ? const Color.fromARGB(255, 230, 231, 232)
                              : Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Order ID
                              SizedBox(
                                width: 200,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$uuid',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),

                              //Order Items and Qty
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: SizedBox(
                                  width: 400,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: widget.orderDataFromHive[index]
                                              [0]
                                          .map<Widget>((eachOrder) {
                                        return Text(
                                          '${eachOrder['item']['productName']} x ${eachOrder['itemCount']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),

                              //Order Time
                              SizedBox(
                                width: 200,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    orderedAt,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),

                              //Order Status
                              SizedBox(
                                width: 200,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: statusColor(orderStatus),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        orderStatus,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Mukta'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //Ready and Cancel Buttons
                              Row(
                                children: [
                                  //Cancel Button
                                  OutlinedButton(
                                      onPressed: () async {
                                        const String orderStatusChangingURL =
                                            "http://localhost:4848/api/food-ready";
                                        //encoding the Order ID in base64
                                        String encodedString =
                                            base64Encode(utf8.encode('$uuid'));

                                        try {
                                          //sending singal to server to change the order status
                                          Response serverResponse = await Dio()
                                              .put(orderStatusChangingURL,
                                                  queryParameters: {
                                                'orderId': encodedString,
                                              });

                                          //only change state if server has done the job successfully
                                          if (serverResponse.statusCode ==
                                              200) {
                                            //changing the order status locally
                                            setState(() {
                                              widget.orderDataFromHive[index][1]
                                                  ['orderStatus'] = 'Delivered';
                                            });
                                          } else {
                                            //job not done properly
                                          }
                                        } catch (e) {
                                          print('Error fetching data: $e');

                                          rethrow;
                                        }

                                        // foodIsReady(uuid, index);
                                      },
                                      child: const Text(
                                        'Deliver',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 22, 209, 28),
                                          fontSize: 15,
                                        ),
                                      )),

                                  //Space Between Ready and Cancel Buttons
                                  const SizedBox(
                                    width: 20,
                                  ),

                                  //Cancel Button
                                  OutlinedButton(
                                      onPressed: () async {
                                        const String orderStatusChangingURL =
                                            "http://localhost:4848/api/food-canceled";
                                        //encoding the Order ID in base64
                                        String encodedString =
                                            base64Encode(utf8.encode('$uuid'));

                                        try {
                                          //sending singal to server to change the order status
                                          Response serverResponse = await Dio()
                                              .put(orderStatusChangingURL,
                                                  queryParameters: {
                                                'orderId': encodedString,
                                              });

                                          //only change state if server has done the job successfully
                                          if (serverResponse.statusCode ==
                                              200) {
                                            //changing the order status locally
                                            setState(() {
                                              widget.orderDataFromHive[index][1]
                                                  ['orderStatus'] = 'Canceled';
                                            });
                                          } else {
                                            //job not done properly
                                          }
                                        } catch (e) {
                                          print('Error fetching data: $e');

                                          rethrow;
                                        }
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 15),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 1,
                          color: Color.fromARGB(255, 230, 231, 232),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  void foodIsReady(int uniqueId, int index) {}

  void foodIsCanceled(int uniqueId, int index) {}

  Color statusColor(String orderStatus) {
    if (orderStatus == 'Pending' || orderStatus == 'pending') {
      return const Color.fromARGB(255, 255, 131, 6);
    } else if (orderStatus == 'Canceled' || orderStatus == 'canceled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
