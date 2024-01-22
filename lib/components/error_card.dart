import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String errorText;
  final String destinationWidgetName;
  final Widget destinationWidget;

  const ErrorCard(
      {super.key,
      required this.errorText,
      required this.destinationWidgetName,
      required this.destinationWidget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 400,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 157, 157),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 11, 11),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              errorText,
              style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => destinationWidget));
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  fixedSize: const Size(150, 20),
                  backgroundColor: const Color.fromARGB(255, 79, 223, 248),
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(
                "Go To $destinationWidgetName",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
