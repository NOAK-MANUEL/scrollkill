

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

Widget numberField(TextEditingController controller) {
  return SizedBox(
    width: 100,
    height: 40,
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
      onChanged: (value) {
        // optional: sync back to model
      },
    ),
  );
}
