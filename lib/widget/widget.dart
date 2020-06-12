import 'package:flutter/material.dart';

Widget BrandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wall",
        style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold),
      ),
      Text("fy", style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold))
    ],
  );
}
