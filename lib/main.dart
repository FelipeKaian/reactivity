import 'package:flutter/material.dart';

void main() {
  print(a(() {
    return "";
  }));
}

a(Function b) {
  return b();
}
