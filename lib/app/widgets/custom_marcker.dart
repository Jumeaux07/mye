import 'package:flutter/material.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class CustomMarcker extends StatelessWidget {
  const CustomMarcker({
    super.key,
    required this.text,
    this.image,
  });
  final String text;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: yellowColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: image == null
            ? Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  height: 30,
                  width: 30,
                  image ?? "",
                )),
      ),
    );
  }
}
