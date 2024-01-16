import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final bool isSubmitting;

  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.isSubmitting});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Align(
            alignment: Alignment.center,
            child: isSubmitting
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    buttonText,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  )),
      ),
    );
  }
}
