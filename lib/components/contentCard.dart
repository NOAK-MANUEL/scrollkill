

import 'package:flutter/material.dart';

Widget contentCard (Widget child){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14)
      ),
      child: child,
    );
}