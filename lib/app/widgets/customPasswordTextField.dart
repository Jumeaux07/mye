import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Custompasswordtextfield extends StatefulWidget {
  Custompasswordtextfield(
      {super.key,
      required this.passwordController,
      this.validator,
      required this.label});
  final TextEditingController passwordController;
  final String label;
  bool _isObscure = true;
  String? Function(String?)? validator;

  @override
  State<Custompasswordtextfield> createState() =>
      _CustompasswordtextfieldState();
}

class _CustompasswordtextfieldState extends State<Custompasswordtextfield> {
  var _errorText;
  void validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = "Mot de passe obligatoire";
      });
    } else if (value.length < 8) {
      setState(() {
        _errorText =
            "Le mot de passe doit être supérieur ou égale à 8 caractères";
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w100,
          ),
        ),
        TextFormField(
          controller: widget.passwordController,
          validator: widget.validator,
          obscureText: widget._isObscure,
          onChanged: (value) {
            validatePassword(value);
          },
          decoration: InputDecoration(
              errorText: _errorText,
              suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget._isObscure = !widget._isObscure;
                    });
                  },
                  child: Icon(widget._isObscure
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined)),
              hintText: "*******",
              border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
