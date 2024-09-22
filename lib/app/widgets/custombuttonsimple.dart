import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.labelSize,
    this.enabled = false,
    this.isLoading = false,
    this.borderColor,
    this.backgroundColor,
    this.labelColor,
    this.width,
    this.height,
  });

  final String label;
  final void Function()? onPressed;
  final bool enabled, isLoading;
  final Color? borderColor, backgroundColor, labelColor;
  final double? width, height;
  final double? labelSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: OutlinedButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith(
                (states) => Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                enabled
                    ? backgroundColor ?? Color(0xFFCBA948)
                    : Color(0xFFCBA948).withOpacity(.5)),
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            side: MaterialStateProperty.resolveWith((states) => BorderSide(
                color: !enabled
                    ? Color(0xFFCBA948).withOpacity(.5)
                    : borderColor ?? Color(0xFFCBA948)))),
        onPressed: !enabled || isLoading ? null : onPressed,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: labelSize ?? 15,
                    fontWeight: FontWeight.w600,
                    color: labelColor ?? Colors.white),
              ),
      ),
    );
  }
}
