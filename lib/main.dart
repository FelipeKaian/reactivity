import 'package:flutter/material.dart';

class a {
  int b = 0;
}

void main() {
  var c = a();
  c.b++;
  print(ObjectKey(c));
  c.b++;
  print(ObjectKey(c));
  // runApp(MaterialApp());
}
