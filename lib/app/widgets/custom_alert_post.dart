import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'custombuttonsimple.dart';

class CustomAlertPost extends StatelessWidget {
   const CustomAlertPost(
      {super.key, this.inputs,});

  final List<Widget>?inputs;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children:[ 
          Container(
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
              children: inputs??[],
            ),
          ),
        ),
      ]),
    );
  }
}
