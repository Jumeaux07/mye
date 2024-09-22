import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'custombuttonsimple.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.message,
      this.success = false,
      required this.onPressed,
      this.icon = Icons.check,
      required this.showAlertIcon});

  final String message;
  final bool success;
  final IconData icon;
  final void Function()? onPressed;
  final bool showAlertIcon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        width: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  showAlertIcon
                      ? success
                          ? UniconsLine.check
                          : UniconsLine.exclamation_triangle
                      : icon,
                  size: 30,
                  color: success
                      ? const Color(0xFF2e7d32)
                      : const Color(0xFFB00020)),
              // Icon(
              //   success
              //   ? UniconsLine.check
              //   : UniconsLine.exclamation_triangle,
              //   size: 30,
              //   color: success ? const Color(0xFF2e7d32) : const Color(0xFFB00020)
              // ),
              const SizedBox(height: 15),
              Text(message,
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),

              CustomButton(
                  onPressed: onPressed,
                  enabled: true,
                  label: success ? "Ok" : "Réessayer"),
            ],
          ),
        ),
      ),
    );
  }
}
