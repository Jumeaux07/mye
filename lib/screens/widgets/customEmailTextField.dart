import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Customemailtextfield extends StatefulWidget {
  Customemailtextfield(
      {super.key, required this.emailController, required this.labal});
  TextEditingController emailController;
  final String labal;
  @override
  State<Customemailtextfield> createState() => _CustomemailtextfieldState();
}

class _CustomemailtextfieldState extends State<Customemailtextfield> {
  var emailError;
  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        emailError = 'Veuillez entrer votre email';
      });
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      setState(() {
        emailError = 'Veuillez entrer un email valide';
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labal,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w100, color: Colors.black),
        ),
        TextFormField(
          controller: widget.emailController,
          onChanged: (value) {
            validateEmail(value);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: emailError,
            hintText: "xxxxxx@email.com",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
    );
  }
}
