import 'package:flutter/material.dart';

class CustomFormatingRules {
  static const Map<String, TextStyle> styles = {
    'b': TextStyle(fontWeight: FontWeight.bold),
    'i': TextStyle(fontStyle: FontStyle.italic),
    'u': TextStyle(decoration: TextDecoration.underline),
  };
}

enum CustomTextFormat {
  bold('b'),
  italic('i'),
  underline('u');

  final String value;
  const CustomTextFormat(this.value);
}
