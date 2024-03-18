// import 'package:flutter/material.dart';

// class OrdersView extends StatefulWidget {
//   final List orderDataFromHive;
//   const OrdersView({super.key, required this.orderDataFromHive});

//   @override
//   State<OrdersView> createState() => _OrdersViewState();
// }

// class _OrdersViewState extends State<OrdersView> {
//   int? _hoveredIndex;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const ScrollPhysics(),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Container(
//               height: 60,
//               color: Colors.orange,
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   //Order ID
//                   SizedBox(
//                     width: 200,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Order ID',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),

//                   //Order Items and Qty
//                   SizedBox(
//                     width: 400,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Items',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),

//                   //Order Status
//                   SizedBox(
//                     width: 200,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Order Time',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 200,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Status',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                   //Ready and Cancel Buttons
//                   SizedBox(
//                     width: 200,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Action',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: widget.orderDataFromHive.length,
//               itemBuilder: (context, index) {
//                 //Unique ID of every order
//                 int uuid = widget.orderDataFromHive[index][1]['uniqueId'];
//                 String orderedAt =
//                     widget.orderDataFromHive[index][1]['orderedAt'];
//                 String orderStatus =
//                     widget.orderDataFromHive[index][1]['orderStatus'];
//                 // String productName =

//                 return MouseRegion(
//                   onEnter: (_) => setState(() => _hoveredIndex = index),
//                   onExit: (_) => setState(() => _hoveredIndex = null),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Column(
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           constraints: const BoxConstraints(minHeight: 80),
//                           color: _hoveredIndex == index
//                               ? const Color.fromARGB(255, 230, 231, 232)
//                               : Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             // crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               //Order ID
//                               SizedBox(
//                                 width: 200,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     '$uuid',
//                                     style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                               ),

//                               //Order Items and Qty
//                               SizedBox(
//                                 width: 400,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: widget.orderDataFromHive[index][0]
//                                         .map<Widget>((eachOrder) {
//                                       return Text(
//                                         '${eachOrder['item']['productName']} x ${eachOrder['itemCount']}',
//                                         style: const TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                               ),

//                               //Order Time
//                               SizedBox(
//                                 width: 200,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     orderedAt,
//                                     style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                               ),

//                               //Order Status
//                               SizedBox(
//                                 width: 200,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     orderStatus,
//                                     style: statusColor(orderStatus),
//                                   ),
//                                 ),
//                               ),
//                               //Ready and Cancel Buttons
//                               Row(
//                                 children: [
//                                   //Cancel Button
//                                   OutlinedButton(
//                                       onPressed: () {
//                                         foodIsReady(uuid);
//                                       },
//                                       child: const Text(
//                                         'Ready',
//                                         style: TextStyle(
//                                           color:
//                                               Color.fromARGB(255, 22, 209, 28),
//                                           fontSize: 15,
//                                         ),
//                                       )),

//                                   //Space Between Ready and Cancel Buttons
//                                   const SizedBox(
//                                     width: 20,
//                                   ),

//                                   //Cancel Button
//                                   OutlinedButton(
//                                       onPressed: () {
//                                         foodIsCanceled(uuid);
//                                       },
//                                       child: const Text(
//                                         'Cancel',
//                                         style: TextStyle(fontSize: 15),
//                                       )),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         const Divider(
//                           height: 0,
//                           thickness: 1,
//                           color: Color.fromARGB(255, 230, 231, 232),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }

// void foodIsReady(int uniqueId) {
//   print('$uniqueId');
// }

// void foodIsCanceled(int uniqueId) {
//   print('$uniqueId');
// }

// TextStyle statusColor(String orderStatus) {
//   if (orderStatus == 'pending') {
//     return const TextStyle(
//         color: Color.fromARGB(255, 192, 126, 3),
//         fontSize: 15,
//         fontWeight: FontWeight.w500);
//   } else if (orderStatus == 'canceled') {
//     return const TextStyle(
//         color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500);
//   } else {
//     return const TextStyle(
//         color: Colors.green, fontSize: 15, fontWeight: FontWeight.w500);
//   }
// }
