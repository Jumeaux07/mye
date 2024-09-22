import 'package:flutter/material.dart';

class Customtextfield extends StatefulWidget {
  const Customtextfield(
      {super.key, required this.textController, required this.label});
  final TextEditingController textController;
  final String label;

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  var _textError;
  void validateText(String value) {
    if (value.isEmpty) {
      setState(() {
        _textError = "${widget.label} obligatoire";
      });
    } else {
      setState(() {
        _textError = null;
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
              fontSize: 22, fontWeight: FontWeight.w100, color: Colors.black),
        ),
        TextFormField(
          controller: widget.textController,
          onChanged: (value) {
            validateText(value);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            focusColor: Color(0xFFCBA948),
            hoverColor: Color(0xFFCBA948),
            errorText: _textError,
            hintText: widget.label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
    );
  }
}
